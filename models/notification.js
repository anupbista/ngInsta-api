const uuid = require('uuid/v4');

module.exports = (sequelize, type) => {
    const Notification = sequelize.define('notification', {
        id: {
            allowNull: false,
            primaryKey: true,
            type: type.UUID,
            defaultValue: uuid(),
        },
        status: {
            type: type.BOOLEAN,
            allowNull: false,
            defaultValue: false //false: not seen & true: seen
        },
        type: {
            type: type.STRING,
            allowNull: false,
        },
        userId: {
            allowNull: false,
            type: type.UUID,
            references: {
                model: 'users',
                key: 'id'
            }
        },
        aliasId: {
            allowNull: false,
            type: type.UUID,
            references: {
                model: 'users',
                key: 'id'
            }
        },
        createdAt: {
            allowNull: false,
            type: type.DATE,
            defaultValue: type.literal('CURRENT_TIMESTAMP')
        },
        updatedAt: {
            allowNull: false,
            type: type.DATE,
            defaultValue: type.literal('CURRENT_TIMESTAMP')
        }
    })

    Notification.beforeCreate( notification => {
        let key = uuid();
        notification.dataValues.id = key;
    });

    return Notification;
}