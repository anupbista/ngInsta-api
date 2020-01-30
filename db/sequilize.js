const Sequelize = require('sequelize')
const UserModel = require('../models/users')
const PostModel = require('../models/posts')
const CommentModel = require('../models/comments')
const LikesModel = require('../models/likes')
const AliasModel = require('../models/alias')
const UserTokenModel = require('../models/usertoken');
const NotificationModel = require('../models/notification');
const SavePostsModel = require('../models/saved');
const MessagesModel = require('../models/messages');

const sequelize = new Sequelize(process.env.DATABASE_URL || "postgres://pqowldxanqdxnu:7fb0636bb0ae86dd50c791f9fcd2ede669471d1ceca89ed01300a8703fba49ac@ec2-54-163-226-238.compute-1.amazonaws.com:5432/d1p54ufr7m889m", {
  host: process.env.DB_HOST || "ec2-54-163-226-238.compute-1.amazonaws.com",
  dialect: 'postgres',
  pool: {
    max: 10,
    min: 0,
    acquire: 30000,
    idle: 10000
  },
  dialectOptions: {
    ssl: true
  }
})

const User = UserModel(sequelize, Sequelize);
const Post = PostModel(sequelize, Sequelize);
const Comment = CommentModel(sequelize, Sequelize);
const Likes  = LikesModel(sequelize, Sequelize);
const Alias = AliasModel(sequelize, Sequelize);
const UserToken = UserTokenModel(sequelize, Sequelize);
const Notification = NotificationModel(sequelize, Sequelize);
const SavedPosts = SavePostsModel(sequelize, Sequelize);
const Messages = MessagesModel(sequelize, Sequelize);

User.hasMany(Post, { foreignKey: { allowNull: false }, onDelete: 'CASCADE' });
Post.belongsTo(User, { foreignKey: { allowNull: false } });

User.hasMany(Comment, { foreignKey: { allowNull: false }, onDelete: 'CASCADE' })
Comment.belongsTo(Post, { foreignKey: { allowNull: false } });
Comment.belongsTo(User, { foreignKey: { allowNull: false } });
Post.hasMany(Comment, { foreignKey: { allowNull: false }, onDelete: 'CASCADE' })

User.hasMany(Likes, { foreignKey: { allowNull: false }, onDelete: 'CASCADE' })
Likes.belongsTo(User, { foreignKey: { allowNull: false } });
Post.hasMany(Likes, { foreignKey: { allowNull: false }, onDelete: 'CASCADE' })
Likes.belongsTo(Post, { foreignKey: { allowNull: false } });

User.hasMany(SavedPosts, { foreignKey: { allowNull: false }, onDelete: 'CASCADE' })
SavedPosts.belongsTo(User, { foreignKey: { allowNull: false } });
Post.hasMany(SavedPosts, { foreignKey: { allowNull: false }, onDelete: 'CASCADE' })
SavedPosts.belongsTo(Post, { foreignKey: { allowNull: false } });

User.hasMany(Alias, { foreignKey: { allowNull: false }, onDelete: 'CASCADE' })
Alias.belongsTo(User, { foreignKey: { allowNull: false } })
User.hasMany(Alias, { foreignKey: { name: 'aliasId', allowNull: false }, onDelete: 'CASCADE'});

User.hasMany(UserToken, { foreignKey: { allowNull: false }, onDelete: 'CASCADE' })
UserToken.belongsTo(User, { foreignKey: { allowNull: false } });

User.hasMany(Notification, { foreignKey: { allowNull: false }, onDelete: 'CASCADE' });
Notification.belongsTo(User, { foreignKey: { allowNull: false } });
Post.hasMany(Notification, { foreignKey: { allowNull: true }, onDelete: 'CASCADE' });
Notification.belongsTo(Post, { foreignKey: { allowNull: true } });

User.hasMany(Messages, {foreignKey: {allowNull: false}});
Messages.belongsTo(User, {foreignKey: {allowNull: false}});
User.hasMany(Messages, { foreignKey: { name: 'receiverId', allowNull: false }});

sequelize.sync({ force: false })
  .then(() => {
    console.log(`Database & tables created!`)
  })

module.exports = {
  User, Post, Comment, Likes, Alias, UserToken, Notification, SavedPosts, Messages, Sequelize
}