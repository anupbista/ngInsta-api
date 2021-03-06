const uuid = require('uuid/v4');

module.exports = (sequelize, type) => {
    const Comment = sequelize.define('comment', {
        id: {
            allowNull: false,
            primaryKey: true,
            type: type.UUID,
            defaultValue: uuid(),
        },
        commentText: {
            type: type.STRING,
            allowNull: false,
        }
    })

    Comment.beforeCreate( comment => {
        let key = uuid();
        comment.dataValues.id = key;
    });

    return Comment;
}