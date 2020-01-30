const uuid = require('uuid/v4'); // ES5

module.exports = (sequelize, type) => {
    const Message = sequelize.define('message', {
        id: {
            allowNull: false,
            primaryKey: true,
            type: type.UUID,
            defaultValue: uuid()
        },
        message: {
            type: type.STRING,
            allowNull: false
        }
    })
    

    Message.beforeCreate( message => {
        let key = uuid();
        message.dataValues.id = key;
    });

    return Message;
}