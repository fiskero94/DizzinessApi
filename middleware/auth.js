const jwt = require('jsonwebtoken');

module.exports = function (request, response, next) {
    try {
        const token = request.header('x-auth-token');
        if (!token) return response.status(401).send('Access denied. No token provided.');

        const decoded = jwt.verify(token, 'jwtPrivateKey');
        request.user = decoded;

        

        next();
    } catch (error) {
        response.status(400).send('Invalid token.');
    }
}