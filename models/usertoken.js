const uuid = require('uuid/v4'); // ES5

module.exports = (sequelize, type) => {
    const UserToken = sequelize.define('usertoken', {
        id: {
            allowNull: false,
            primaryKey: true,
            type: type.UUID,
            defaultValue: uuid()
        },
        token: {
            type: type.STRING,
            allowNull: false
        }
    })

    UserToken.beforeCreate(async (user, options) => {
        let key = uuid();
        user.dataValues.id = key;
    })

    return UserToken;
}