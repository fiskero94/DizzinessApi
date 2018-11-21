const express = require('express');
const router = express.Router();
const Joi = require('joi');
const pool = require('../database/pool');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

router.get('/', getAllPatients);
router.get('/:id', getPatient);
router.post('/', createPatient);
router.put('/:id', updatePatient);
router.delete('/:id', deletePatient);

async function getAllPatients(request, response) {

}

async function getPatient(request, response) {

}

async function createPatient(request, response) {
    console.log(request.body);
    
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

        const token = jwt.sign({ id: id, type: 'patient' }, 'jwtPrivateKey');
        console.log(token);
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