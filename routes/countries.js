const express = require('express');
const router = express.Router();
const Joi = require('joi');
const pool = require('../database/pool');
const errors = require('../errors.js');

router.get('/', getAllCountries);
router.get('/:countrycode', getCountry);

async function getAllCountries(request, response) {
    try {
        const selected = await pool.query('SELECT code, name FROM Country');
        return response.send(selected.rows);
    } catch(error) {
        return response.status(500).send(errors.internalServerError);
    }
}

async function getCountry(request, response) {
    const result = validate(request);
    if (result.error) {
        return response.status(400).send({ 
            code: errors.validation.code, 
            message: result.error.details[0].message 
        });
    }

    try {
        const selected = await pool.query(
            'SELECT code, name FROM Country WHERE code = $1', 
            [request.params.countrycode]
        );

        if (selected.rows.length !== 1)
            return response.status(404).send(errors.elementNotFound);

        return response.send(selected.rows[0]);
    } catch(error) {
        return response.status(500).send(errors.internalServerError);
    }
}

function validate(request) {
    return Joi.validate(request.params, {
        countrycode: Joi.string().required()
    });
}

module.exports = router;