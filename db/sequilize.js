const Sequelize = require('sequelize')
const UserModel = require('../models/users')
const PostModel = require('../models/posts')
const CommentModel = require('../models/comments')

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

User.hasMany(Post, { foreignKey: { allowNull: false }, onDelete: 'CASCADE' });
User.hasMany(Comment, { foreignKey: { allowNull: false }, onDelete: 'CASCADE' })
Post.hasMany(Comment, { foreignKey: { allowNull: false }, onDelete: 'CASCADE' })

sequelize.sync({ force: false })
  .then(() => {
    console.log(`Database & tables created!`)
  })

module.exports = {
  User, Post, Comment
}