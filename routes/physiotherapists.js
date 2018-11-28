const express = require('express');
const router = express.Router();
const Joi = require('joi');
const pool = require('../database/pool');
const auth = require('../middleware/auth');

router.get('/:id', auth, getPhysiotherapistById);

async function getPhysiotherapistById(request, response) {
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
                Physiotherapist.organisation_id
            FROM UserBase INNER JOIN Physiotherapist 
            ON UserBase.id = Physiotherapist.user_id WHERE id = $1;`, 
            [id]
        );

        if (selected.rows.length !== 1) 
        return response.status(404).send('A physiotherapist with the given id could not be found.');

        return response.send(selected.rows[0]);
    }

    catch(error) {
        return response.status(500).send(error.message);
    }
}

module.exports = router;