const express = require('express');
const router = express.Router();
const Joi = require('joi');
const pool = require('../database/pool');
const auth = require('../middleware/auth');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const errors = require('../errors.js');

router.get('/', auth, getAllPatients);
router.get('/:id', auth, getPatient);
router.post('/', createPatient);
router.put('/:id', auth, updatePatient);
router.delete('/:id', auth, deletePatient);

async function getAllPatients(request, response) {
    
}

async function getPatient(request, response) {
    const id = parseInt(request.params.id);
    if (isNaN(id)) return response.status(400).send('Id must be a number.');
    
    try {
        const selected = await pool.query(`
            SELECT 
                UserBase.id, 
                UserBase.first_name, 
                UserBase.last_name, 
                UserBase.email,
                UserBase.created, 
                UserBase.updated, 
                Patient.location_id, 
                Patient.phone,
                Patient.birth_date, 
                Patient.sex, 
                Patient.height, 
                Patient.weight 
            FROM UserBase INNER JOIN Patient 
            ON UserBase.id = Patient.user_id WHERE id = $1;`, 
            [id]
        );

        if (selected.rows.length !== 1) 
            return response.status(404).send('A patient with the given id could not be found.');

        return response.send(selected.rows[0]);
    } catch(error) {
        return response.status(500).send(error.message);
    }
}

async function createPatient(request, response) {
    const result = validate(request);
    if (result.error) 
        return response.status(400).send({ code: errors.validation.code, message: result.error.details[0].message });

    const salt = await bcrypt.genSalt(10);
    const hash = await bcrypt.hash(request.body.password, salt);

    const client = await pool.connect();
    try {
        await client.query('BEGIN');
        const user = await client.query(`INSERT INTO UserBase(type, first_name, last_name, email, password) 
            VALUES($1, $2, $3, $4, $5) RETURNING id`, [
            'patient', 
            request.body.first_name, 
            request.body.last_name, 
            request.body.email, 
            hash,
        ]);

        const id = user.rows[0].id;
        await client.query('INSERT INTO Patient(user_id) VALUES($1)', [ id ]);
        await client.query('COMMIT');

        const token = jwt.sign({ 
            sub: id, 
            name: `${request.body.first_name} ${request.body.last_name}`, 
            type: 'patient' 
        }, 'jwtPrivateKey');
        return response.send({ token: token });
    } catch(error) {
        await client.query('ROLLBACK');

        if (error.hasOwnProperty('code') && error.code == "23505") {
            return response.status(400).send({ 
                code: errors.userAlreadyRegistered.code, 
                message: errors.userAlreadyRegistered.message
            });
        }

        return response.status(500).send({ code: errors.internalServerError.code, message: error.message });
    } finally {
        client.release();
    }
}

async function updatePatient(request, response) {

}

async function deletePatient(request, response) {

}

function validate(request) {
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

module.exports = router;