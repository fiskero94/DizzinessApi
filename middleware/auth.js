const jwt = require('jsonwebtoken');

module.exports = function (request, response, next) {
    const token = request.header('x-auth-token');
    if (!token) return response.status(401).send('Access denied. No token provided.');

    console.log(request.header);

    try {
        console.log("end:" + token + ":begin");
        const decoded = jwt.verify(token, 'jwtPrivateKey');
        request.user = decoded;
        next();
    } catch (error) {
        console.log(error);
        response.status(400).send('Invalid token.');
    }
}