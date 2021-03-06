module.exports = {
    validation: { code: "40001", message:"Validation error." },
    invalidEmailOrPassword: { code: "40002", message: "Invalid email or password." },
    userAlreadyRegistered: { code: "40003", message: "User already registered." },
    noToken: { code: "40004", message: "Access denied. No token provided." },
    invalidToken: { code: "40005", message: "Invalid token." },
    urlParameterNumber: { code: "40006", message: "The url parameter must be a number." },
    currentPasswordIncorrect: { code: "40007", message: "The current password is incorrect." },
    locationNotFound: { code: "40008",  message: "The city/country does not exist." },
    relationExists: { code: "40009", message: "Relation already exists." },
    levelRequired: { code: "40010", message: "Dizziness register requires a level from 0-10." },
    onlyPhysiotherapist: { code: "40301", message: "The endpoint can only be used by physiotherapists."},
    onlyPatient: { code: "40302", message: "The endpoint can only be used by patients."},
    accessDenied: { code: "40303", message: "You do not have access to the specified element." },
    userNotFound: { code: "40401", message: "The user no longer exists." },
    elementNotFound: { code: "40402", message: "The element could not be found." },
    internalServerError: { code: "50001", message: "Internal server error." }
}