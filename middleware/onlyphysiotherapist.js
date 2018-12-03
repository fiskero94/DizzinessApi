const errors = require('../errors.js');

module.exports = async (request, response, next) => {
    if (request.user.type != 'physiotherapist') {
        return response.status(403).send(errors.onlyPhysiotherapist);
    }

    next();
}