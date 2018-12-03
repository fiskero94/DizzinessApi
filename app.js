// Config
const config = require('config');
const apiConfig = config.get('api');

// Packages
const helmet = require('helmet');
const express = require('express');
const app = express();
var morgan = require('morgan');
var boolParser = require('express-query-boolean');
var bodyParser = require('body-parser');

// Middleware
app.use(express.json());
app.use(helmet());
app.use(morgan('tiny'));
app.use(bodyParser.json());
app.use(boolParser());

// Routes
app.use('/v1/wipes', require('./routes/wipes'));
app.use('/v1/patients', require('./routes/patients'));
app.use('/v1/dizzinesses', require('./routes/dizzinesses'));
app.use('/v1/exercises', require ('./routes/exercises'));
app.use('/v1/logins', require('./routes/logins'));
app.use('/v1/customexercises', require('./routes/customexercises'));
app.use('/v1/patients/:userid/favoriteexercises', require('./routes/favoriteexercises'));
app.use('/v1/recommendations', require('./routes/recommendations'));
app.use('/v1/physiotherapists', require('./routes/physiotherapists'));
app.use('/v1/journallogs', require('./routes/journallogs'));
app.use('/v1/locations', require('./routes/locations'));
app.use('/v1/journalentries', require('./routes/journalentries'));
app.use('/v1/stepcounts', require('./routes/stepcounts'));

// Run
app.listen(apiConfig.port, () => console.log('Listening on port ' + apiConfig.port + '...'));