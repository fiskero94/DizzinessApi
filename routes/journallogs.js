const express = require('express');
const router = express.Router();
const Joi = require('joi');
const pool = require('../database/pool');
const auth = require('../middleware/auth');

router.get('/', auth, getAllJournalLogs);

async function getAllJournalLogs(request, response) {
    try {
        const selected = await pool.query(`
        SELECT
            CAST (journalentry.created AS DATE)
        FROM journalentry
            WHERE id IN (
                SELECT 
                    min(id) 
                FROM journalentry
                WHERE 
                    patient_id = $1
                GROUP BY 
                    CAST(created AS DATE)
            )
        UNION
        SELECT
            CAST (dizziness.created AS DATE)
        FROM dizziness
            WHERE id IN (
                SELECT 
                    min(id) 
                FROM dizziness
                WHERE 
                    patient_id = $1
                GROUP BY 
                    CAST(created AS DATE)
            )`, [request.user.sub]
            );

        return response.send(selected.rows);
    }

    catch(error) {
        return response.status(500).send(error.message);
    }
}

module.exports = router;