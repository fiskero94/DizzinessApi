const { Pool } = require('pg');
const config = require('config');
const dbConfig = config.get('database');

const pool = new Pool({
    user: dbConfig.user,
    host: dbConfig.host,
    database: dbConfig.database,
    password: dbConfig.password,
    port: dbConfig.port,
});

pool.on('error', (err, client) => {
    console.error('Unexpected error on idle client', err);
    process.exit(-1);
});

module.exports = pool;