const express = require('express');
const router = express.Router();
const Joi = require('joi');
const pool = require('../database/pool');
const auth = require('../middleware/auth');

router.get('/', auth, getAllFavoriteExercises);
router.post('/', auth, createFavoriteExercise);
router.delete('/:id', auth, deleteFavoriteExercise);

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

async function deleteFavoriteExercise(request, response) {
    try {
        const exercise_id = parseInt(request.params.id);
        if (isNaN(exercise_id)) return response.status(400).send('Id must be a number');
        const deleted = await pool.query('DELETE FROM exercisefavorite WHERE exercise_id = $1 and patient_id = $2 RETURNING *', [exercise_id, request.user.sub]);
        
        if (deleted.rows.length !== 1)
            return response.status(404).send('An exercise with the given id could not be found.');
            
        return response.send(deleted.rows[0]);
    } catch(error) {
        return response.status(500).send(error.message);
    }
}

async function createFavoriteExercise(request, response) {
    try {
        const result = validate(request);
        if (result.error) 
            return response.status(400).send(result.error.details[0].message);
        const created = await pool.query('INSERT INTO exercisefavorite (exercise_id, patient_id) VALUES ($1, $2) RETURNING *', [request.body.exercise_id, request.user.sub]);
        
        if (created.rows.length !== 1)
            return response.status(404).send('Something went wrong.');

        return response.send(created.rows[0]);
    } catch(error) {
        return response.status(500).send(error.message);
    }
}

function validate(request) {
    return Joi.validate(request.body, {
        exercise_id: Joi.number().required(),
    });
}

module.exports = router;