const express = require('express');
const router = express.Router();
const Joi = require('joi');
const pool = require('../database/pool');
const auth = require('../middleware/auth');

router.get('/', auth, getAllDizzinesses);
router.get('/:id', getDizziness);
router.post('/', createDizziness);
router.put('/:id', updateDizziness);
router.delete('/:id', deleteDizziness);

async function getAllDizzinesses(request, response) {
    try {
        const selected = await pool.query(`
        SELECT id,
            patient_id,
            exercise_id,
            level,
            note,
            created,
            updated
            FROM dizziness
            WHERE patient_id = $1 AND CAST (created AS DATE) = $2
        `, [request.user.sub, request.query.date]
            );

        return response.send(selected.rows);
    }

    catch(error) {
        return response.status(500).send(error.message);
    }
}

async function getDizziness(request, response) {
    const id = parseInt(request.params.id);
    if (isNaN(id)) 
        return response.status(400).send('Id must be a number.');
          
    try {
        const selected = await pool.query('SELECT * FROM dizziness WHERE id = $1', [id]);
        
        if (selected.rows.length !== 1)
            return response.status(404).send('A dizziness with the given id could not be found.');
            
        return response.send(selected.rows[0]);
    } catch(error) {
        return response.status(500).send(error.message);
    }
}

async function createDizziness(request, response) {
    const result = validate(request);
    if (result.error) 
        return response.status(400).send(result.error.details[0].message);

    try {
        const query = 'INSERT INTO dizziness (patient_id, exercise_id, level, note) VALUES ($1, $2, $3, $4) RETURNING *';
        const inserted = await pool.query(query, [
            request.body.patient_id,
            request.body.exercise_id,
            request.body.level, 
            request.body.note
        ]);

        return response.send(inserted.rows[0]);
    } catch(error) {
        return response.status(500).send(error.message);
    }
}

async function updateDizziness(request, response) {

}

async function deleteDizziness(request, response) {
    const id = parseInt(request.params.id);
    if (isNaN(id)) return response.status(400).send('Id must be a number');

    try {
        const deleted = await pool.query('DELETE FROM dizziness WHERE id = $1', [id]);
        
        if (deleted.rows.length !== 1)
            return response.status(404).send('A dizziness with the given id could not be found.');
            
        return response.send(deleted.rows[0]);
    } catch(error) {
        return response.status(500).send(error.message);
    }
}

function validate(request) {
    return Joi.validate(request.body, {
        patient_id: Joi.number().required(),
        exercise_id: Joi.number(),
        level: Joi.number().min(1).max(10).required(),
        note: Joi.string().allow('').max(1000).required(),
    });
}

module.exports = router;