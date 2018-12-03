const express = require('express');
const router = express.Router();
const Joi = require('joi');
const pool = require('../database/pool');
const auth = require('../middleware/auth');
const errors = require('../errors.js');
const getpatients = require('../middleware/getpatients');

router.get('/:id', [auth, getpatients], getLocation);
router.get('/:id', auth, getLocation);
router.post('/', auth, createLocation);
router.put('/:id', auth, updateLocation);
router.delete('/:id', auth, deleteLocation);

async function getLocation(request, response) {
    const id = parseInt(request.params.id);
    if (isNaN(id)) return response.status(400).send(errors.urlParameterNumber);
          
    try {
        const location = await pool.query(`
            SELECT id, zip_code, country_code, address 
            FROM location WHERE id = $1`, [id]
        );
        
        if (location.rows.length !== 1)
            return response.status(404).send(errors.elementNotFound);

        const organisation = await pool.query('SELECT COUNT(*) FROM Organisation WHERE location_id = $1', [id]);

        if (organisation.rows[0].count != 1) {
            const patient = await pool.query('SELECT user_id AS id FROM Patient WHERE location_id = $1', [id]);

            if (patient.rows.length !== 1)
                return response.status(403).send(errors.accessDenied);

            if (request.user.type == 'patient' && request.user.sub !== patient.rows[0].id) 
                return response.status(403).send(errors.accessDenied);
        
            if (request.user.type == 'physiotherapist' && !request.user.patients.list.includes(patient.rows[0].id))
                return response.status(403).send(errors.accessDenied);
        }
        
        return response.send(location.rows[0]);
    } catch(error) {
        return response.status(500).send(error.message);
    }
}

async function createLocation(request, response) {
    const result = validate(request);
    if (result.error) {
        return response.status(400).send({ 
            code: errors.validation.code, 
            message: result.error.details[0].message 
        });
    }

    try {
        const inserted = await pool.query(`
            INSERT INTO Location (zip_code, country_code, address) 
            VALUES ($1, $2, $3) RETURNING *`,    
            [request.body.zip_code,
            request.body.country_code,
            request.body.address
        ]);

        return response.send(inserted.rows[0]);
    } catch(error) {
        if (error.hasOwnProperty('code') && error.code == "23503") 
            return response.status(400).send(errors.cityNotFound);
        
        return response.status(500).send(errors.internalServerError);
    }
}

async function updateLocation(request, response) {
    const id = parseInt(request.params.id);
    if (isNaN(id)) return response.status(400).send('Id must be a number.');

    const result = validate(request);
    if (result.error) {
        return response.status(400).send({ 
            code: errors.validation.code, 
            message: result.error.details[0].message 
        });
    }

    try {
        const updated = pool.query(
            'UPDATE Location SET zip_code = $1, country_code = $2, address = $3 WHERE id = $4',
            [request.body.zip_code, request.body.country_code, address, id]
        );

        if (updated.rows.length !== 1)
            return response.status(404).send(errors.elementNotFound);

        return response.send(updated.rows[0]);
    } catch(error) {
        if (error.hasOwnProperty('code') && error.code == "23503") 
            return response.status(400).send(errors.cityNotFound);

        return response.status(500).send(errors.internalServerError);
    }
}

async function deleteLocation(request, response) {
    const id = parseInt(request.params.id);
    if (isNaN(id)) return response.status(400).send(errors.urlParameterNumber);

}



function validate(request) {
    return Joi.validate(request.body, {
        zip_code: Joi.string().max(50).required(),
        country_code: Joi.string().max(50).required(),
        address: Joi.string().max(1000).required(),
    });
}

module.exports = router;