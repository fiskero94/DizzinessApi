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
app.use('/v1/logins', require('./routes/logins'));
app.use('/v1/patients', require('./routes/patients'));
app.use('/v1/patients', require('./routes/stepcounts'));
app.use('/v1/patients', require('./routes/journalentries'));
app.use('/v1/patients', require('./routes/journallogs'));
app.use('/v1/patients', require('./routes/dizzinesses'));
app.use('/v1/patients', require('./routes/recommendations'));
app.use('/v1/patients', require('./routes/customexercises'));
app.use('/v1/patients', require('./routes/favoriteexercises'));
app.use('/v1/physiotherapists', require('./routes/physiotherapists'));
app.use('/v1/cities', require('./routes/cities'));
app.use('/v1/countries', require('./routes/countries'));
app.use('/v1/exercises', require ('./routes/exercises'));

// Run
app.listen(apiConfig.port, () => console.log('Listening on port ' + apiConfig.port + '...'));