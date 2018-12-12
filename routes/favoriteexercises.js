const express = require('express');
const router = express.Router();
const Joi = require('joi');
const pool = require('../database/pool');
const auth = require('../middleware/auth');
const errors = require('../errors.js');
const onlypatient = require('../middleware/onlypatient');
const getpatients = require('../middleware/getpatients');

router.get('/:userid/favoriteexercises/', [auth, getpatients], getAllFavoriteExercises);
router.post('/:userid/favoriteexercises/', [auth, onlypatient], createFavoriteExercise);
router.delete('/:userid/favoriteexercises/:id', [auth, onlypatient], deleteFavoriteExercise);

async function getAllFavoriteExercises(request, response) {
    const userid = parseInt(request.params.userid);
    if (isNaN(userid)) return response.status(400).send(errors.urlParameterNumber);
    
    if (request.user.type == 'patient' && request.user.sub != userid) 
        return response.status(403).send(errors.accessDenied);

    if (request.user.type == 'physiotherapist' && !request.user.patients.list.includes(userid))
        return response.status(403).send(errors.accessDenied);

    try {
        const selected = await pool.query(`
            SELECT id, author_id, name, description, created, updated
            FROM exercise WHERE id in (SELECT exercise_id FROM exercisefavorite WHERE patient_id = $1)`, 
            [userid]
        );

        return response.send(selected.rows);
    } catch(error) {
        return response.status(500).send(errors.internalServerError);
    }
}

async function createFavoriteExercise(request, response) {
    const userid = parseInt(request.params.userid);
    if (isNaN(userid)) return response.status(400).send(errors.urlParameterNumber);
    
    if (request.user.sub != userid) 
        return response.status(403).send(errors.accessDenied);

    const result = validate(request);
    if (result.error) {
        return response.status(400).send({
            code: errors.validation.code,
            message: result.error.details[0].message
        });
    }
    
    try {
        const created = await pool.query(`
            INSERT INTO exercisefavorite (exercise_id, patient_id) VALUES ($1, $2) RETURNING *`, 
            [request.body.exercise_id, userid]
        );

        return response.send(created.rows[0]);
    } catch(error) {
        if (error.hasOwnProperty('code') && error.code == "23505") 
            return response.status(400).send(errors.relationExists);

        return response.status(500).send(errors.internalServerError);
    }
}

async function deleteFavoriteExercise(request, response) {
    const userid = parseInt(request.params.userid);
    const exercise_id = parseInt(request.params.id);
    if (isNaN(userid)) return response.status(400).send(errors.urlParameterNumber);
    if (isNaN(exercise_id)) return response.status(400).send(errors.urlParameterNumber);

    if (request.user.sub != userid) 
        return response.status(403).send(errors.accessDenied);

    try {
        const deleted = await pool.query(`
            DELETE FROM exercisefavorite WHERE exercise_id = $1 and patient_id = $2 RETURNING *`, 
            [exercise_id, userid]
        );
        
        if (deleted.rows.length !== 1)
            return response.status(404).send(errors.elementNotFound);
            
        return response.send(deleted.rows[0]);
    } catch(error) {
        return response.status(500).send(errors.internalServerError);
    }
}

function validate(request) {
    return Joi.validate(request.body, {
        exercise_id: Joi.number().required(),
    });
}

module.exports = router;