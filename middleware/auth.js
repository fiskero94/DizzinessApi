const jwt = require('jsonwebtoken');

module.exports = function (request, response, next) {
    const token = req.header('x-auth-token');
    if (!token) return response.status(401).send('Access denied. No token provided.');

    try {
        const decoded = jwt.verify(token, 'jwtPrivateKey');
        request.user = decoded;
        next();
    } catch (error) {
        response.status(400).send('Invalid token.');
    }
}