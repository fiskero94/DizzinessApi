const express = require('express');
const router = express.Router();
const Joi = require('joi');
const pool = require('../database/pool');
const auth = require('../middleware/auth');
const errors = require('../errors.js');

router.get('/', auth, getAllJournalEntries);
router.post('/', auth, createJournalEntry);

async function getAllJournalEntries(request, response) {
    try {
        const selected = await pool.query(`
        SELECT id,
            patient_id,
            note,
            created,
            updated
            FROM journalentry
            WHERE patient_id = $1 AND CAST (created AS DATE) = $2
        `, [request.user.sub, request.query.date]
            );

        return response.send(selected.rows);
    }

    catch(error) {
        return response.status(500).send(error.message);
    }
}

async function createJournalEntry(request, response) {
    const result = validate(request);
        if (result.error) return response.status(400).send({ 
            code: errors.validation.code, 
            message: result.error.details[0].message 
        });
    try {
        const created = await pool.query(`
        INSERT INTO journalentry(
            patient_id,
            note) 
        VALUES(
            $1,
            $2
        )
        RETURNING *
        `, [request.user.sub, request.body.note]
            );

            if (created.rows.length !== 1)
            return response.status(404).send('Something went wrong.');

        return response.send(created.rows[0]);
    }

    catch(error) {
        return response.status(500).send(error.message);
    }
}

function validate(request) {
    return Joi.validate(request.body, {
        note: Joi.string().max(1000).required(),
    });
}

module.exports = router;