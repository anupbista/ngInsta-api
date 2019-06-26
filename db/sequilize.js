const Sequelize = require('sequelize')
const UserModel = require('../models/users')
const PostModel = require('../models/posts')
const CommentModel = require('../models/comments')
const LikesModel = require('../models/likes')
const AliasModel = require('../models/alias')

const sequelize = new Sequelize('ngInsta', 'admin-dev', 'admin-dev', {
  host: 'localhost',
  dialect: 'mysql',
  pool: {
    max: 10,
    min: 0,
    acquire: 30000,
    idle: 10000
  }
})

const User = UserModel(sequelize, Sequelize);
const Post = PostModel(sequelize, Sequelize);
const Comment = CommentModel(sequelize, Sequelize);
const Likes  = LikesModel(sequelize, Sequelize);
const Alias = AliasModel(sequelize, Sequelize);

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
User.hasMany(Alias, { foreignKey: { allowNull: false }, onDelete: 'CASCADE' })
Alias.belongsTo(User, { foreignKey: { allowNull: false } })
User.hasMany(Alias, { foreignKey: { name: 'aliasId', allowNull: false }, onDelete: 'CASCADE'});

sequelize.sync({ force: false })
  .then(() => {
    console.log(`Database & tables created!`)
  })

module.exports = {
  User, Post, Comment, Likes, Alias, Sequelize
}