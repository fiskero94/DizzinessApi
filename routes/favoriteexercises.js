const express = require('express');
const router = express.Router();
const Joi = require('joi');
const pool = require('../database/pool');
const auth = require('../middleware/auth');

router.get('/', auth, getAllFavoriteExercises);

async function getAllFavoriteExercises(request, response) {
    try {
        const selected = await pool.query(`
        SELECT 
            id,
            author_id,
            name,
            description,
            created,
            updated
            FROM exercise
            WHERE id in (
                SELECT exercise_id FROM exercisefavorite WHERE patient_id = $1
            )`, [request.user.sub]
            );

        return response.send(selected.rows);
    }

    catch(error) {
        return response.status(500).send(error.message);
    }
}

module.exports = router;