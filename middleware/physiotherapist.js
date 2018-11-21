module.exports = function (request, response, next) {
    if (request.user.type != 'physiotherapist') return response.status(403).send('Access denied.');
    next();
}