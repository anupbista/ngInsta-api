const uuid = require('uuid/v4');

module.exports = (sequelize, type) => {
    const Alias = sequelize.define('alias', {
        id: {
            allowNull: false,
            primaryKey: true,
            type: type.UUID,
            defaultValue: uuid()
        },
        followRequested: {
            type: type.BOOLEAN,
            allowNull: false,
            defaultValue: false
        }
    })

    Alias.beforeCreate( alias => {
        let key = uuid();
        alias.dataValues.id = key;
    });

    return Alias;
}