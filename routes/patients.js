const express = require('express');
const router = express.Router();
const BaseJoi = require('joi');
const Extension = require('joi-date-extensions');
const Joi = BaseJoi.extend(Extension);
const pool = require('../database/pool');
const auth = require('../middleware/auth');
const getpatients = require('../middleware/getpatients');
const onlyphysiotherapist = require('../middleware/onlyphysiotherapist');
const onlypatient = require('../middleware/onlypatient');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const errors = require('../errors.js');

router.get('/', [auth, onlyphysiotherapist, getpatients], getAllPatients);
router.get('/:id', [auth, getpatients], getPatient);
router.post('/', createPatient);
router.put('/:id', [auth, onlypatient], updatePatient);

async function getAllPatients(request, response) {
    try {
        const selected = await pool.query(`
            SELECT 
                UserBase.id, 
                UserBase.first_name, 
                UserBase.last_name, 
                UserBase.email,
                UserBase.created, 
                UserBase.updated, 
                Patient.phone,
                Patient.birth_date, 
                Patient.sex, 
                Patient.height, 
                Patient.weight,
                Patient.zip_code,
                Patient.country_code,
                Patient.address 
            FROM UserBase 
            INNER JOIN Patient ON UserBase.id = Patient.user_id 
            WHERE id IN ${request.user.patients.inString}`
        );

        return response.send(selected.rows);
    } catch(error) {
        return response.status(500).send(errors.internalServerError);
    }
}

async function getPatient(request, response) {
    const id = parseInt(request.params.id);
    if (isNaN(id)) return response.status(400).send(errors.urlParameterNumber);
    
    if (request.user.type == 'patient' && request.user.sub != id) 
        return response.status(403).send(errors.accessDenied);

    if (request.user.type == 'physiotherapist' && !request.user.patients.list.includes(id))
        return response.status(403).send(errors.accessDenied);

    try {
        const selected = await pool.query(`
            SELECT 
                UserBase.id, 
                UserBase.first_name, 
                UserBase.last_name, 
                UserBase.email,
                UserBase.created, 
                UserBase.updated, 
                Patient.phone,
                Patient.birth_date, 
                Patient.sex, 
                Patient.height, 
                Patient.weight,
                Patient.zip_code,
                Patient.country_code,
                Patient.address 
            FROM UserBase 
            INNER JOIN Patient ON UserBase.id = Patient.user_id 
            WHERE id = $1`, 
            [id]
        );

        if (selected.rows.length !== 1) 
            return response.status(404).send(errors.elementNotFound);

        return response.send(selected.rows[0]);
    } catch(error) {
        return response.status(500).send(errors.internalServerError);
    }
}

async function createPatient(request, response) {
    const result = validateCreate(request);
    if (result.error) {
        return response.status(400).send({ 
            code: errors.validation.code, 
            message: result.error.details[0].message 
        });
    }

    const salt = await bcrypt.genSalt(10);
    const hash = await bcrypt.hash(request.body.password, salt);

    const client = await pool.connect();
    try {
        await client.query('BEGIN');
        const user = await client.query(`
            INSERT INTO UserBase(type, first_name, last_name, email, password) 
            VALUES($1, $2, $3, $4, $5) RETURNING id`, 
            ['patient', 
            request.body.first_name, 
            request.body.last_name, 
            request.body.email, 
            hash,
        ]);

        const id = user.rows[0].id;
        await client.query('INSERT INTO Patient(user_id) VALUES($1)', [id]);
        await client.query('COMMIT');

        const token = jwt.sign({ 
            sub: id, 
            name: `${request.body.first_name} ${request.body.last_name}`, 
            type: 'patient' 
        }, 'jwtPrivateKey');
        return response.send({ token: token });
    } catch(error) {
        await client.query('ROLLBACK');

        if (error.hasOwnProperty('code') && error.code == "23505") 
            return response.status(400).send(errors.userAlreadyRegistered);

        return response.status(500).send(errors.internalServerError);
    } finally {
        client.release();
    }
}

async function updatePatient(request, response) {
    const id = parseInt(request.params.id);
    if (isNaN(id)) return response.status(400).send(errors.urlParameterNumber);
    if (request.user.sub != id) return response.status(403).send(errors.accessDenied);

    const result = validateUpdate(request);
    if (result.error) {
        return response.status(400).send({ 
            code: errors.validation.code, 
            message: result.error.details[0].message 
        });
    }

    const client = await pool.connect();
    try {
        await client.query('BEGIN');

        if (request.body.password != null && request.body.current_password != null) {
            const selected = await client.query('SELECT password FROM UserBase WHERE id = $1', [id]);
            if (selected.rows.length !== 1) return response.status(404).send(errors.elementNotFound);
            
            const validPassword = await bcrypt.compare(request.body.current_password, selected.rows[0].password);
            if (!validPassword) return response.status(400).send(errors.currentPasswordIncorrect);

            const salt = await bcrypt.genSalt(10);
            const hash = await bcrypt.hash(request.body.password, salt);

            await client.query('UPDATE UserBase SET password = $1 WHERE id = $2 RETURNING *', [hash, id]);
        }

        await client.query(`UPDATE Patient SET phone = $1, birth_date = $2, sex = $3, height = $4,
            weight = $5, zip_code = $6, country_code = $7, address = $8 WHERE user_id = $9`,
            [request.body.phone,
            request.body.birth_date,
            request.body.sex,
            request.body.height,
            request.body.weight,
            request.body.zip_code,
            request.body.country_code,
            request.body.address,
            id
        ]);

        const updated = await client.query(`
            SELECT 
                UserBase.id, 
                UserBase.first_name, 
                UserBase.last_name, 
                UserBase.email,
                UserBase.created, 
                UserBase.updated, 
                Patient.phone,
                Patient.birth_date, 
                Patient.sex, 
                Patient.height, 
                Patient.weight,
                Patient.zip_code,
                Patient.country_code,
                Patient.address
            FROM UserBase 
            INNER JOIN Patient ON UserBase.id = Patient.user_id 
            WHERE id = $1`, 
            [id]
        );

        if (updated.rows.length !== 1)
            return response.status(404).send(errors.elementNotFound);
        
        await client.query('COMMIT');
        return response.send(updated.rows[0]);
    } catch(error) {
        if (error.hasOwnProperty('code') && error.code == "23503") 
            return response.status(400).send(errors.locationNotFound);

        await client.query('ROLLBACK');
        return response.status(500).send(errors.internalServerError);      
    } finally {
        client.release();
    }
}

function validateCreate(request) {
    return Joi.validate(request.body, {
        first_name: Joi.string().trim().max(255).required(),
        last_name: Joi.string().trim().max(255).required(),
        email: Joi.string().trim().max(255).email().required(),
        password: Joi.string().max(255).regex(/(?=.*\d)(?=.*[a-z])(?=.*[A-Z])/).required().options({
            language: { string: { regex: { 
                base: 'The password must have one uppercase character, one lowercase character, and a number.' 
            }}}
        }),
    });
}

function validateUpdate(request) {
    return Joi.validate(request.body, {
        current_password: Joi.string().allow(null).max(255),
        password: Joi.string().allow(null).max(255).regex(/(?=.*\d)(?=.*[a-z])(?=.*[A-Z])/).options({
            language: { string: { regex: { 
                base: 'The password must have one uppercase character, one lowercase character, and a number.' 
            }}}
        }),
        phone: Joi.string().allow(null).trim().max(255).required(),
        birth_date: Joi.date().allow(null).format('YYYY-MM-DD').required(),
        sex: Joi.string().allow(null).valid(['male', 'female']).required(),
        height: Joi.number().allow(null).min(0).max(32767).required(),
        weight: Joi.number().allow(null).min(0).max(32767).required(),
        zip_code: Joi.string().allow(null).max(50).required(),
        country_code: Joi.string().allow(null).max(50).required(),
        address: Joi.string().allow(null).max(255).required()
    });
}

module.exports = router;