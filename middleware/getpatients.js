const pool = require('../database/pool');
const errors = require('../errors.js');

module.exports = async (request, response, next) => {
    if (request.user.type == 'physiotherapist') {
        try {
            const patients = await pool.query(`
                SELECT Request.patient_id AS id
                FROM Request 
                INNER JOIN Period ON Request.id = Period.request_id
                WHERE 
                    Request.accepted = true AND 
                    Period.end_date IS NULL AND 
                    Request.physiotherapist_id = $1`,
                [request.user.sub]
            );

            let list = [];
            for (let i = 0; i < patients.rows.length; i++)
                list.push(Number(patients.rows[i].id));

            let inString = '(';
            for (let i = 0; i < patients.rows.length; i++) 
                inString += patients.rows[i].id + ',';
            inString = inString.substring(0, inString.length - 1);
            inString += ')';

            request.user.patients = {
                list: list,
                inString: inString
            }
        } catch (error) {
            return response.status(500).send(errors.internalServerError);
        }
    }

    next();
}