const express = require('express');
const router = express.Router();
const Joi = require('joi');
const pool = require('../database/pool');
const auth = require('../middleware/auth');
const errors = require('../errors.js');
const getpatients = require('../middleware/getpatients');

router.get('/:userid/journallogs/', [auth, getpatients], getAllJournalLogs);

async function getAllJournalLogs(request, response) {
    const userid = parseInt(request.params.userid);
    if (isNaN(userid)) return response.status(400).send(errors.urlParameterNumber);
    
    if (request.user.type == 'patient' && request.user.sub != userid) 
        return response.status(403).send(errors.accessDenied);

    if (request.user.type == 'physiotherapist' && !request.user.patients.list.includes(userid))
        return response.status(403).send(errors.accessDenied);

    try {
        const selected = await pool.query(`
            SELECT CAST (journalentry.created AS DATE)
            FROM journalentry WHERE id IN (
                SELECT min(id) 
                FROM journalentry
                WHERE patient_id = $1
                GROUP BY CAST(created AS DATE)
            )
            UNION
            SELECT CAST (dizziness.created AS DATE)
            FROM dizziness WHERE id IN (
                SELECT min(id) 
                FROM dizziness
                WHERE patient_id = $1
                GROUP BY CAST(created AS DATE)
            )`, [userid]
        );

        return response.send(selected.rows);
    } catch(error) {
        return response.status(500).send(errors.internalServerError);
    }
}

module.exports = router;