const uuid = require('uuid/v4'); // ES5
const bcrypt = require("bcrypt");

module.exports = (sequelize, type) => {
    const User = sequelize.define('user', {
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
        displayName: {
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
            allowNull: true,
            defaultValue: "uploads/profile/default-user.png"
        },
        privateProfile: {
            type: type.BOOLEAN,
            allowNull: false,
            defaultValue: false
        },
        followers: {
            type: type.INTEGER,
            defaultValue: 0
        },
        following: {
            type: type.INTEGER,
            defaultValue: 0
        },
        noOfPosts: {
            type: type.INTEGER,
            defaultValue: 0
        },
        bio: {
            type: type.STRING,
            allowNull: true,
        },
        website: {
            type: type.STRING,
            allowNull: true,
        },
        phoneNumber: {
            type: type.STRING,
            allowNull: true,
        },
        gender:{
            type: type.STRING,
            allowNull: true,
        },
    })

    User.beforeCreate(async (user, options) => {
        let key = uuid();
        user.dataValues.id = key;

        const salt = await bcrypt.genSalt(10);
        const passwordHash = await bcrypt.hash(user.password, salt);
        user.password = passwordHash;
    })

    User.prototype.isValidPassword = async function(password) {
        const isValid = await bcrypt.compare(password, this.password)
        return isValid;
    }

    return User;
}