const express = require('express');
const router = express.Router();
const pool = require('../database/pool');
const auth = require('../middleware/auth');
const errors = require('../errors.js');

router.get('/', auth, getAllExercises);
router.get('/:id', auth, getExercise);

async function getAllExercises(request, response) {
    try {
        const selected = await pool.query(`
            SELECT id, author_id, name, description, created, updated
            FROM exercise WHERE custom = false`
        );

        return response.send(selected.rows);
    } catch(error) {
        return response.status(500).send(errors.internalServerError);
    }
}

async function getExercise(request, response) {
    const id = parseInt(request.params.id);
    if (isNaN(id)) return response.status(400).send(errors.urlParameterNumber);
    
    try {
        const selected = await pool.query(`
            SELECT id, author_id, name, description, created, updated
            FROM exercise WHERE id = $1 AND custom = false`, 
            [id]
        );

        if (selected.rows.length !== 1) 
            return response.status(404).send(errors.elementNotFound);

        return response.send(selected.rows[0]);
    } catch(error) {
        return response.status(500).send(errors.internalServerError);
    }
}

module.exports = router;