const express = require('express');
const router = express.Router();
const Joi = require('joi');
const pool = require('../database/pool');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const errors = require('../errors.js');
var fs = require('fs');

router.post('/', createWipe);

async function createWipe(request, response) {
    try {
        const scripts = [
            fs.readFileSync('database/drop.sql', 'utf8').replace(/\\"/g, '"'),
            fs.readFileSync('database/create.sql', 'utf8').replace(/\\"/g, '"'),
            fs.readFileSync('database/fill.sql', 'utf8').replace(/\\"/g, '"')
        ];

        for (let index = 0; index < scripts.length; index++) {
            try {
                await pool.query(scripts[index].replace(/\\"/g, '"'));
            } catch (error) {
                return response.status(500).send({ code: errors.internalServerError.code, message: error.message, index: index, script: scripts[index], error: error });
            }
            
        }
    } catch (error) {
        return response.status(500).send({ code: errors.internalServerError.code, message: error.message });
    }
}

module.exports = router;