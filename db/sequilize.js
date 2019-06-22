const Sequelize = require('sequelize')
const UserModel = require('../models/users')

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

const User = UserModel(sequelize, Sequelize)

sequelize.sync({ force: true })
  .then(() => {
    console.log(`Database & tables created!`)
  })

module.exports = {
  User
}