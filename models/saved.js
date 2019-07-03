const uuid = require('uuid/v4');

module.exports = (sequelize, type) => {
    const SavePosts = sequelize.define('savepost', {
        id: {
            allowNull: false,
            primaryKey: true,
            type: type.UUID,
            defaultValue: uuid(),
        }
    })

    SavePosts.beforeCreate( SavePosts => {
        let key = uuid();
        SavePosts.dataValues.id = key;
    });

    return SavePosts;
}