const express = require('express');
const router = express.Router();
const pool = require('../database/pool');
const auth = require('../middleware/auth');
const errors = require('../errors.js');
const getpatients = require('../middleware/getpatients');

router.get('/:userid/recommendations/', [auth, getpatients], getAllRecommendedExercises);

async function getAllRecommendedExercises(request, response) {
    const userid = parseInt(request.params.userid);
    if (isNaN(userid)) return response.status(400).send(errors.urlParameterNumber);
    
    if (request.user.type == 'patient' && request.user.sub != userid) 
        return response.status(403).send(errors.accessDenied);

    if (request.user.type == 'physiotherapist' && !request.user.patients.list.includes(userid))
        return response.status(403).send(errors.accessDenied);

    try {
        const selected = await pool.query(`
            SELECT id, physiotherapist_id, exercise_id, patient_id, note, updated, created
            FROM recommendation WHERE patient_id = $1`, 
            [userid]
        );

        return response.send(selected.rows);
    } catch(error) {
        if (error.hasOwnProperty('code') && error.code == "23505") 
            return response.status(400).send(errors.relationExists);

        return response.status(500).send(errors.internalServerError);
    }
}

module.exports = router;