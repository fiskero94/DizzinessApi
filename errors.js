module.exports = {
    validation: { code: "40001", message:"Validatin error." },
    invalidEmailOrPassword: { code: "40002", message: "Invalid email or password." },
    userAlreadyRegistered: { code: "40003", message: "User already registered." },
    noToken: { code: "40004", message: "Access denied. No token provided." },
    invalidToken: { code: "40005", message: "Invalid token." },
    userNotFound: { code: "40401", message: "The user no longer exists." },
    internalServerError: { code: "50001", message: "Internal server error." }
}