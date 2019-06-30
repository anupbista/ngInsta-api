const uuid = require('uuid/v4');

module.exports = (sequelize, type) => {
    const Post = sequelize.define('post', {
        id: {
            allowNull: false,
            primaryKey: true,
            type: type.UUID,
            defaultValue: uuid()
        },
        latitude: {
            type: type.FLOAT,
            allowNull: true
        },
        longitude: {
            type: type.FLOAT,
            allowNull: true
        },
        postImage: {
            type: type.STRING,
            allowNull: false,
        },
        caption: {
            type: type.STRING,
            allowNull: true,
        },
        likesNo: {
            type: type.INTEGER,
            defaultValue: 0
        },
        commentsNo: {
            type: type.INTEGER,
            defaultValue: 0
        }
    })

    Post.beforeCreate( post => {
        let key = uuid();
        post.dataValues.id = key;
    });


    return Post;
}