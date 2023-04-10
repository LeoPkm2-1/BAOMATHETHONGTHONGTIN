require('dotenv').config({path: '../.env'})

const getEnv = (env_key) => {
    return process.env[env_key]
}

module.exports = getEnv;