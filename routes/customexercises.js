const express = require('express');
const router = express.Router();
const pool = require('../database/pool');
const auth = require('../middleware/auth');
const errors = require('../errors.js');
const getpatients = require('../middleware/getpatients');

router.get('/:userid/customexercises/', [auth, getpatients], getAllCustomExercises);

async function getAllCustomExercises(request, response) {
    const userid = parseInt(request.params.userid);
    if (isNaN(userid)) return response.status(400).send(errors.urlParameterNumber);
    
    if (request.user.type == 'patient' && request.user.sub != userid) 
        return response.status(403).send(errors.accessDenied);

    if (request.user.type == 'physiotherapist' && !request.user.patients.list.includes(userid))
        return response.status(403).send(errors.accessDenied);
    
    try {
        const selected = await pool.query(`
            SELECT id, author_id, name, description, created, updated
            FROM exercise WHERE id in (
                SELECT exercise_id FROM customexercisepatient WHERE patient_id = $1
            )`, [userid]
        );

        return response.send(selected.rows);
    } catch(error) {
        return response.status(500).send(errors.internalServerError);
    }
}

module.exports = router;