const express = require('express');
const router = express.Router();
const pool = require('../database/pool');
const auth = require('../middleware/auth');
const errors = require('../errors.js');
const getpatients = require('../middleware/getpatients');
const onlypatient = require('../middleware/onlypatient');
const BaseJoi = require('joi');
const Extension = require('joi-date-extensions');
const Joi = BaseJoi.extend(Extension);

router.get('/:userid/stepcounts', [auth, getpatients], getAllStepCounts);
router.post('/:userid/stepcounts', [auth, onlypatient], createStepCount);
router.put('/:userid/stepcounts/:id', [auth, onlypatient], updateStepCount);

async function getAllStepCounts(request, response) {
    const userid = parseInt(request.params.userid);
    if (isNaN(userid)) return response.status(400).send(errors.urlParameterNumber);
    
    if (request.user.type == 'patient' && request.user.sub != userid) 
        return response.status(403).send(errors.accessDenied);

    if (request.user.type == 'physiotherapist' && !request.user.patients.list.includes(userid))
        return response.status(403).send(errors.accessDenied);
    
    try {
        const selected = await pool.query(`
            SELECT id, patient_id, count, date FROM stepcount WHERE patient_id = $1`, 
            [userid]
        );
            
        return response.send(selected.rows);
    } catch(error) {
        return response.status(500).send(errors.internalServerError);
    }
}

async function createStepCount(request, response) {
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
            INSERT INTO stepcount (patient_id, count, date) VALUES ($1, $2, $3) RETURNING *`, 
            [request.body.patient_id, request.body.count, request.body.date]
        );

        return response.send(created.rows[0]);
    } catch(error) {
        return response.status(500).send(errors.internalServerError);
    }
}

async function updateStepCount(request, response) {
    const userid = parseInt(request.params.userid);
    const stepid = parseInt(request.params.id);
    if (isNaN(userid) || isNaN(stepid)) return response.status(400).send(errors.urlParameterNumber);
    
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
        const updated = await pool.query(`
            UPDATE stepcount SET count = $1 WHERE id = $2 RETURNING *`, 
            [request.body.count, stepid]
        );

        return response.send(updated.rows[0]);
    } catch(error) {
        return response.status(500).send(errors.internalServerError);
    }
}

function validate(request) {
    return Joi.validate(request.body, {
        patient_id: Joi.number().required(),
        count: Joi.number().required(),
        date: Joi.string().required(),
    });
}

module.exports = router;