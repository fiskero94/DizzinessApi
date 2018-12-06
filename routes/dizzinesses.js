const express = require('express');
const router = express.Router();
const Joi = require('joi');
const pool = require('../database/pool');
const auth = require('../middleware/auth');
const errors = require('../errors.js');
const onlypatient = require('../middleware/onlypatient');
const getpatients = require('../middleware/getpatients');

router.get('/:userid/dizzinesses', [auth, getpatients], getAllDizzinesses);
router.get('/:userid/dizzinesses/:id', [auth, getpatients], getDizziness);
router.post('/:userid/dizzinesses', [auth, onlypatient], createDizziness);
router.delete('/:userid/dizzinesses/:id', [auth, onlypatient], deleteDizziness);

async function getAllDizzinesses(request, response) {
    const userid = parseInt(request.params.userid);
    if (isNaN(userid)) return response.status(400).send(errors.urlParameterNumber);

    if (request.user.type == 'patient' && request.user.sub != userid) 
        return response.status(403).send(errors.accessDenied);

    if (request.user.type == 'physiotherapist' && !request.user.patients.list.includes(userid))
        return response.status(403).send(errors.accessDenied);

    try {
        let query = `SELECT id, patient_id, exercise_id, level, note, created, updated
            FROM dizziness WHERE patient_id = $1`;
        let params = [userid];

        if(request.query.date !== undefined)
        {
            query += " AND CAST (created AS DATE) = $2";
            params.push(request.query.date);
        }

        if(request.query.levelgiven !== undefined)
        {
            if(request.query.levelgiven) query += " AND level IS NOT NULL";
            else query += " AND level IS NULL";
        }

        const selected = await pool.query(query, params);
        return response.send(selected.rows);
    } catch(error) {
        return response.status(500).send(error.message);
    }
}

async function getDizziness(request, response) {
    const id = parseInt(request.params.id);
    const userid = parseInt(request.params.userid);
    if (isNaN(id)) return response.status(400).send(errors.urlParameterNumber);
    if (isNaN(userid)) return response.status(400).send(errors.urlParameterNumber);

    if (request.user.type == 'patient' && request.user.sub != userid) 
        return response.status(403).send(errors.accessDenied);

    if (request.user.type == 'physiotherapist' && !request.user.patients.list.includes(userid))
        return response.status(403).send(errors.accessDenied);
          
    try {
        const selected = await pool.query(`
            SELECT id, patient_id, exercise_id, level, note, created, updated 
            FROM dizziness WHERE id = $1 AND patient_id = $2`, 
            [id, userid]
        );
        
        if (selected.rows.length !== 1)
            return response.status(404).send(errors.elementNotFound);
            
        return response.send(selected.rows[0]);
    } catch(error) {
        return response.status(500).send(errors.internalServerError);
    }
}

async function createDizziness(request, response) {
    const userid = parseInt(request.params.userid);
    if (isNaN(userid)) return response.status(400).send(errors.urlParameterNumber);

    if (request.user.sub != userid) 
        return response.status(403).send(errors.accessDenied);

    const result = validate(request);
    if (result.error) {
        return response.status(400).send({ 
            code: errors.validation, 
            message: result.error.details[0].message 
        });
    }

    try {
        const inserted = await pool.query(`
            INSERT INTO dizziness (patient_id, exercise_id, level, note) 
            VALUES ($1, $2, $3, $4) RETURNING *`, 
            [userid,
            request.body.exercise_id,
            request.body.level, 
            request.body.note
        ]);

        return response.send(inserted.rows[0]);
    } catch(error) {
        return response.status(500).send(error.message);
    }
}

async function deleteDizziness(request, response) {
    const id = parseInt(request.params.id);
    const userid = parseInt(request.params.userid);
    if (isNaN(id)) return response.status(400).send(errors.urlParameterNumber);
    if (isNaN(userid)) return response.status(400).send(errors.urlParameterNumber);

    if (request.user.sub != userid) 
        return response.status(403).send(errors.accessDenied);

    try {
        const deleted = await pool.query(`
            DELETE FROM dizziness WHERE id = $1 
            AND patient_id = $2 RETURNING *`, 
            [id, userid]
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
        exercise_id: Joi.number().allow(null).required(),
        level: Joi.number().allow(null).min(1).max(10).required(),
        note: Joi.string().allow('').max(1000).required(),
    });
}

module.exports = router;