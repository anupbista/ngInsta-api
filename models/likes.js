const uuid = require('uuid/v4');

module.exports = (sequelize, type) => {
    const Likes = sequelize.define('like', {
        id: {
            allowNull: false,
            primaryKey: true,
            type: type.UUID,
            defaultValue: uuid(),
        }
    })

    Likes.beforeCreate( like => {
        let key = uuid();
        like.dataValues.id = key;
    });

    return Likes;
}