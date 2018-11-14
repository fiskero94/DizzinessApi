// Config
const config = require('config');
const apiConfig = config.get('api');

// Packages
const helmet = require('helmet');
const express = require('express');
const app = express();

// Middleware
app.use(express.json());
app.use(helmet());

// Routes
app.use('/api/dizziness', require('./routes/dizziness'));

// Run
app.listen(apiConfig.port, () => console.log('Listening on port ' + apiConfig.port + '...'));