const express = require('express');
const router = express.Router();
const pool = require('../database/pool');
const errors = require('../errors.js');

router.get('/', getAllCities);
router.get('/:id', getCity);

async function getAllCities(request, response) {
    try {
        const selected = await pool.query('SELECT zip_code, country_code, name FROM City');
        return response.send(selected.rows);
    } catch(error) {
        return response.status(500).send(errors.internalServerError);
    }
}

async function getCity(request, response) {
    const id = parseInt(request.params.id);
    if (isNaN(id)) return response.status(400).send(errors.urlParameterNumber);

    try {
        const selected = await pool.query('SELECT zip_code, country_code, name FROM City WHERE id = $1', [id]);

        if (selected.rows.length !== 1)
            return response.status(404).send(errors.elementNotFound);

        return response.send(selected.rows[0]);
    } catch(error) {
        return response.status(500).send(errors.internalServerError);
    }
}

module.exports = router;