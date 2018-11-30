const express = require('express');
const router = express.Router();
const Joi = require('joi');
const pool = require('../database/pool');
const auth = require('../middleware/auth');

router.get('/', auth, getAllExercises);
router.get('/:id', auth, getExercise);

async function getAllExercises(request, response) {
    try {
        const selected = await pool.query(`
        SELECT id,
            author_id,
            name,
            description,
            created,
            updated
            FROM exercise
            WHERE custom = false;`
            );

        return response.send(selected.rows);
    }

    catch(error) {
        return response.status(500).send(error.message);
    }
}

async function getExercise(request, response) {
    const id = parseInt(request.params.id);
    if (isNaN(id)) return response.status(400).send('Id must be a number.');
    
    try {
        const selected = await pool.query(`
            SELECT 
                id,
                author_id,
                name,
                description,
                created,
                updated,
                custom
            FROM exercise
            WHERE id = $1`, 
            [id]
        );

        if (selected.rows.length !== 1) 
            return response.status(404).send('An exercise with the given id could not be found.');

        return response.send(selected.rows[0]);
    } catch(error) {
        return response.status(500).send(error.message);
    }
}

module.exports = router;