const express = require('express');
const router = express.Router();
const Joi = require('joi');
const pool = require('../database/pool');
const auth = require('../middleware/auth');

router.get('/', auth, getAllExercises);

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

        return response.send(selected.rows[0]);
    }

    catch(error) {
        return response.status(500).send(error.message);
    }
}

module.exports = router;