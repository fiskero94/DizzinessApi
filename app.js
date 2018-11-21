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
app.use('/v1/patients', require('./routes/patients'));
app.use('/v1/dizzinesses', require('./routes/dizzinesses'));
app.use('/v1/exercises', require ('./routes/exercises'));

// Run
app.listen(apiConfig.port, () => console.log('Listening on port ' + apiConfig.port + '...'));