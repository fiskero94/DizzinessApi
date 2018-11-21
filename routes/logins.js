const express = require('express');
const router = express.Router();
const Joi = require('joi');
const pool = require('../database/pool');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

router.post('/', createLogin);

async function createLogin(request, response) {
    const result = validate(request);
    if (result.error) 
        return response.status(400).send(result.error.details[0].message);

    try {
        const selected = await pool.query(`
            SELECT id, type, first_name, last_name, email, password 
            FROM UserBase WHERE email = $1`,
            [request.body.email]
        );

        if (selected.rows.length !== 1) 
            return response.status(400).send('Invalid email or password.');

        const user = selected.rows[0];
        const validPassword = await bcrypt.compare(request.body.password, user.password);
        if (!validPassword) return response.status(400).send('Invalid email or password.');

        const token = jwt.sign({ 
            sub: user.id, 
            name: `${user.first_name} ${user.last_name}`, 
            type: user.type 
        }, 'jwtPrivateKey');
        return response.send({ token: token });
    } catch (error) {
        return response.status(500).send(error.message);
    }
}

function validate(request) {
    return Joi.validate(request.body, {
        email: Joi.string().trim().max(255).email().required(),
        password: Joi.string().max(255).required()
    });
}

module.exports = router;