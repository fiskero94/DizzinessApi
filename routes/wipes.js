const express = require('express');
const router = express.Router();
const errors = require('../errors.js');
const { exec } = require('child_process');
const pool = require('../database/pool');

router.post('/', createWipe);

async function createWipe(request, response) {
    exec('wipe.bat', function(error, stdout, stderr) {
        if (error) return response.status(500).send({ 
            code: errors.internalServerError.code, 
            message: error.message 
        });
        else return response.send('Database wiped succesfully.');
    });
}

module.exports = router;