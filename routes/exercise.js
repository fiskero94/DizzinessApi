const express = require('express');
const router = express.Router();
const Joi = require('joi');
const pool = require('../database/pool');

router.get('/', getAllExercises);
router.get('/:id', getExercise);
router.post('/', createExercise);
router.put('/:id', updateExercise);
router.delete('/:id', deleteExercise);

async function getAllExercises(request, response) {
    try {
        const selected = await pool.query('SELECT * FROM exercise');
        return response.send(selected.rows);
    } catch(error) {
        return response.status(500).send(error.message);
    }
}

async function getExercise(request, response) {
    
}

async function createExercise(request, response) {
    
}

async function updateExercise(request, response) {

}

async function deleteExercise(request, response) {
    
}

function validate(request) {
    
}

module.exports = router;