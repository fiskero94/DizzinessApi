const express = require('express');
const router = express.Router();
const Joi = require('joi');
const pool = require('../database/pool');
const auth = require('../middleware/auth');

router.get('/', auth, getAllRecommendedExercises);

async function getAllRecommendedExercises(request, response) {
    try {
        const selected = await pool.query(`
        SELECT id,
        physiotherapist_id,
        exercise_id,
        patient_id,
        note,
        updated,
        created
        FROM recommendation
        WHERE patient_id = $1
            `, [request.user.sub]
            );

        return response.send(selected.rows);
    }

    catch(error) {
        return response.status(500).send(error.message);
    }
}

module.exports = router;