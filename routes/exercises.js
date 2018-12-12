const express = require('express');
const router = express.Router();
const pool = require('../database/pool');
const auth = require('../middleware/auth');
const errors = require('../errors.js');
const onlyphysiotherapist = require('../middleware/onlyphysiotherapist');
const BaseJoi = require('joi');
const Extension = require('joi-date-extensions');
const Joi = BaseJoi.extend(Extension);

router.get('/', auth, getAllExercises);
router.get('/:id', auth, getExercise);
router.post('/', [auth, onlyphysiotherapist], createExercise);

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

async function createExercise(request, response) {
    const result = validate(request);
    if (result.error) {
        return response.status(400).send({
            code: errors.validation.code,
            message: result.error.details[0].message
        });
    }
    
    try {
        const created = await pool.query(`
            INSERT INTO exercise (author_id, name, description, custom) VALUES ($1, $2, $3, false) RETURNING *`, 
            [request.body.author_id, request.body.exercise_name, request.body.exercise_description]
        );

        return response.send(created.rows[0]);
    } catch(error) {
        return response.status(500).send(errors.internalServerError);
    }
}

function validate(request) {
    return Joi.validate(request.body, {
        exercise_name: Joi.string().trim().max(1000).required(),
        exercise_description: Joi.string().trim().max(1000).required(),
        author_id: Joi.number().required(),
    });
}

module.exports = router;