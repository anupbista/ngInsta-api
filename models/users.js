const uuid = require('uuid/v4'); // ES5

module.exports = (sequelize, type) => {
    return sequelize.define('user', {
        id: {
            allowNull: false,
            primaryKey: true,
            type: type.UUID,
            defaultValue: uuid()
        },
        username: {
            type: type.STRING,
            allowNull: false
        },
        password: {
            type: type.STRING,
            allowNull: false
        },
        email: {
            type: type.STRING,
            allowNull: false,
            validate: {
                isEmail: true,
            }
        },
        userImage: {
            type: type.STRING,
        },
        privateProfile: {
            type: type.BOOLEAN,
            allowNull: false,
            defaultValue: false
        }
    })
}