const express = require('express');
const router = express.Router();
const Joi = require('joi');
const pool = require('../database/pool');
const auth = require('../middleware/auth');
const errors = require('../errors.js');
const onlypatient = require('../middleware/onlypatient');
const getpatients = require('../middleware/getpatients');

router.get('/:userid/journalentries/', [auth, getpatients], getAllJournalEntries);
router.post('/:userid/journalentries/', [auth, onlypatient], createJournalEntry);

async function getAllJournalEntries(request, response) {
    const userid = parseInt(request.params.userid);
    if (isNaN(userid)) return response.status(400).send(errors.urlParameterNumber);
    
    if (request.user.type == 'patient' && request.user.sub != userid) 
        return response.status(403).send(errors.accessDenied);

    if (request.user.type == 'physiotherapist' && !request.user.patients.list.includes(userid))
        return response.status(403).send(errors.accessDenied);
    
    try {
        let query = 'SELECT id, patient_id, note, created, updated FROM JournalEntry WHERE patient_id = $1';
        let params = [userid];

        if (request.query.date !== undefined) {
            query += ' AND CAST (created AS DATE) = $2';
            params.push(request.query.date);
        }

        const selected = await pool.query(query, params);
        return response.send(selected.rows);
    } catch(error) {
        return response.status(500).send(errors.internalServerError);
    }
}

async function createJournalEntry(request, response) {
    const userid = parseInt(request.params.userid);
    if (isNaN(userid)) return response.status(400).send(errors.urlParameterNumber);
    
    if (request.user.type == 'patient' && request.user.sub != userid) 
        return response.status(403).send(errors.accessDenied);

    const result = validate(request);
    if (result.error) return response.status(400).send({ 
        code: errors.validation.code, 
        message: result.error.details[0].message 
    });

    try {
        const created = await pool.query(`
            INSERT INTO journalentry(patient_id, note) 
            VALUES($1, $2) RETURNING *`, 
            [userid, request.body.note]
        );

        return response.send(created.rows[0]);
    } catch(error) {
        return response.status(500).send(errors.internalServerError);
    }
}

function validate(request) {
    return Joi.validate(request.body, {
        note: Joi.string().max(1000).required(),
    });
}

module.exports = router;