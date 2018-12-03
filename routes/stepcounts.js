const express = require('express');
const router = express.Router();
const Joi = require('joi');
const pool = require('../database/pool');
const auth = require('../middleware/auth');

router.get('/', auth, getAllStepCounts);

async function getAllStepCounts(request, response) {
    try {
        const selected = await pool.query(`
        SELECT 
            id,
            patient_id,
            count,
            date
            FROM stepcount
            WHERE patient_id = $1`, [request.user.sub]
            );
            
        return response.send(selected.rows);
    }

    catch(error) {
        return response.status(500).send(error.message);
    }
}

module.exports = router;