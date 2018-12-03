const express = require('express');
const router = express.Router();
const pool = require('../database/pool');
const auth = require('../middleware/auth');
const errors = require('../errors.js');

router.get('/', auth, getAllPhysiotherapists);
router.get('/:id', auth, getPhysiotherapist);

async function getAllPhysiotherapists(request, response) {
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
            FROM UserBase 
            INNER JOIN Physiotherapist ON UserBase.id = Physiotherapist.user_id`
        );

        return response.send(selected.rows);
    } catch(error) {
        return response.status(500).send(errors.internalServerError);
    }
}

async function getPhysiotherapist(request, response) {
    const id = parseInt(request.params.id);
    if (isNaN(id)) return response.status(400).send(errors.urlParameterNumber);

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
            FROM UserBase 
            INNER JOIN Physiotherapist ON UserBase.id = Physiotherapist.user_id 
            WHERE id = $1;`, 
            [id]
        );

        if (selected.rows.length !== 1) 
            return response.status(404).send(errors.elementNotFound);

        return response.send(selected.rows[0]);
    } catch(error) {
        return response.status(500).send(error.message);
    }
}

module.exports = router;