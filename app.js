// Config
const config = require('config');
const apiConfig = config.get('api');

// Packages
const helmet = require('helmet');
const express = require('express');
const app = express();
var morgan = require('morgan');

// Middleware
app.use(express.json());
app.use(helmet());
app.use(morgan('tiny'));

// Routes
app.use('/v1/patients', require('./routes/patients'));
app.use('/v1/dizzinesses', require('./routes/dizzinesses'));
app.use('/v1/exercises', require ('./routes/exercises'));
app.use('/v1/logins', require('./routes/logins'));
app.use('/v1/customexercises', require('./routes/customexercises'));
app.use('/v1/favoriteexercises', require('./routes/favoriteexercises'));
app.use('/v1/recommendations', require('./routes/recommendations'));

// Run
app.listen(apiConfig.port, () => console.log('Listening on port ' + apiConfig.port + '...'));