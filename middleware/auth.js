const jwt = require('jsonwebtoken');
const pool = require('../database/pool');
const errors = require('../errors.js');

module.exports = async (request, response, next) => {
    const token = request.header('x-auth-token');
    if (!token) return response.status(401).send(errors.noToken);
    
    try {
        const decoded = jwt.verify(token, 'jwtPrivateKey');
        request.user = decoded;
    } catch (error) {
        return response.status(400).send(errors.invalidToken);
    }

    try {
        const selected = await pool.query('SELECT COUNT(*) FROM UserBase WHERE id = $1', [request.user.sub]);
        if (selected.rows[0].count != 1) return response.status(404).send(errors.userNotFound);
    } catch (error) {
        return response.status(500).send(errors.internalServerError);
    }
    
    next();
}