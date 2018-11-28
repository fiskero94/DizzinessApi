const express = require('express');
const router = express.Router();
const Joi = require('joi');
const pool = require('../database/pool');
const auth = require('../middleware/auth');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

router.get('/', auth, getAllPatients);
router.get('/:id', auth, getPatient);
router.post('/', createPatient);
router.put('/:id', auth, updatePatient);
router.delete('/:id', auth, deletePatient);

async function getAllPatients(request, response) {//mangler specifikke patienter til physio
    try {
        const selected = await pool.query(`
        SELECT location_id,
            phone,
            birth_date,
            sex,
            height,
            weight
        FROM Patient`
        );
        return response.send(selected.rows);
    }

    catch(error) {
        return response.status(500).send(error.message);
    }
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
        return response.status(400).send(result.error.details[0].message);

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

        if (error.hasOwnProperty('code') && error.code == "23505") 
            return response.status(400).send('User already registered.');

        return response.status(500).send(error);
    } finally {
        client.release();
    }
}

async function updatePatient(request, response) {
    const id = parseInt(request.params.id);
    if (isNaN(id)) return response.status(400).send('Id must be a number.');

    const client = await pool.connect();
    try {
        await client.query('BEGIN');
        const updatedPatient = await client.query(`
            UPDATE Patient
            SET 
                location_id = $1,           
                phone = $2,
                birth_date = $3, 
                sex = $4, 
                height = $5, 
                weight = $6                
            WHERE user_id = $7 RETURNING *`, 
            [request.body.location_id,
            request.body.phone,
            request.body.birth_date,
            request.body.sex,
            request.body.height,
            request.body.weight,
            id]

        );  
        const updatedUser = await client.query(`
            UPDATE UserBase
            SET
                email = $1,
                password = $2
            WHERE id = $3 RETURNING *`,
            [request.body.email,
            request.body.password,
            id]
        );
        
        if (updatedPatient.rows.length !==1 || updatedUser.rows.length !==1 )
            return response.status(404).send('A user with the given id could not be found.');

        console.log(updatedUser.rows[0].id);

        let patient = {
            id: updatedUser.rows[0].id,
            first_name: updatedUser.rows[0].first_name,
            last_name: updatedUser.rows[0].last_name,
            email: updatedUser.rows[0].email,
            created: updatedUser.rows[0].created,
            updated: updatedUser.rows[0].updated
        };

        if (typeof updatedPatient.rows[0].location_id !== 'undefined' ) 
            patient.location_id = updatedPatient.rows[0].location_id;

        if (typeof updatedPatient.rows[0].phone !== 'undefined' ) 
            patient.phone = updatedPatient.rows[0].phone;

        if (typeof updatedPatient.rows[0].birth_date !== 'undefined' ) 
            patient.birth_date = updatedPatient.rows[0].birth_date;

        if (typeof updatedPatient.rows[0].sex !== 'undefined' ) 
            patient.sex = updatedPatient.rows[0].sex;
        
        if (typeof updatedPatient.rows[0].height !== 'undefined' ) 
            patient.height = updatedPatient.rows[0].height;

        if (typeof updatedPatient.rows[0].weight !== 'undefined' ) 
            patient.weight = updatedPatient.rows[0].weight;

        await client.query('COMMIT');
        return response.send(patient);               
    }      
    catch(error) {
        await client.query('ROLLBACK');
        return response.status(500).send(error.message);      
    }   
    finally {
        client.release();
    }
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