const uuid = require('uuid/v4');

module.exports = (sequelize, type) => {
    const Alias = sequelize.define('alias', {
        id: {
            allowNull: false,
            primaryKey: true,
            type: type.UUID,
            defaultValue: uuid(),
        },
        followRequested: {
            type: type.UUID,
            allowNull: false,
            defaultValue: false
        }
    })

    Alias.beforeCreate( like => {
        let key = uuid();
        like.dataValues.id = key;
    });

    return Alias;
}