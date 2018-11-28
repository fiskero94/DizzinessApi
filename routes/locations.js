const express = require('express');
const router = express.Router();
const Joi = require('joi');
const pool = require('../database/pool');
const auth = require('../middleware/auth');

router.post('/', auth, createLocation);
router.get('/:id', auth, getLocation);


async function createLocation(request, response){
    const result = validate(request);
    if (result.error) 
        return response.status(400).send(result.error.details[0].message);

    try {
        const query = 'INSERT INTO location (zip_code, address) VALUES ($1, $2) RETURNING *';
        const inserted = await pool.query(query, [
            request.body.zip_code, 
            request.body.address
        ]);

        return response.send(inserted.rows[0]);
    } catch(error) {
        return response.status(500).send(error.message);
    }
}

async function getLocation(request, response) {
    const id = parseInt(request.params.id);
    if (isNaN(id)) 
        return response.status(400).send('Id must be a number.');
          
    try {
        const selected = await pool.query('SELECT * FROM location WHERE id = $1', [id]);
        
        if (selected.rows.length !== 1)
            return response.status(404).send('A dizziness with the given id could not be found.');
            
        return response.send(selected.rows[0]);
    } catch(error) {
        return response.status(500).send(error.message);
    }
}

function validate(request) {
    return Joi.validate(request.body, {
        zip_code: Joi.string().max(50).required(),
        address: Joi.string().max(1000).required(),
    });
}
module.exports = router;