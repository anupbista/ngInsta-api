const JWT = require('jsonwebtoken');

const { User } = require('../db/sequilize')
const { JWT_SECRET } = require('../config/config')

signToken = user => {
    return JWT.sign({
        iss: 'ngInsta',
        sub: user.id,
        iat: new Date().getTime(),
        exp: new Date().setDate( new Date().getDate() + 1 )
    }, JWT_SECRET)
}

module.exports = {
    signUp: async (req, res) => {
        console.log('UsersController.signUp() called');
        // check if user with the email exists
        const user = await User.findOne({ where: { email: req.body.email } })
        if(user){
            return res.status(403).json({message: "User with the email already exists."})
        }
        // add new user
        
        User.create(req.body)
        .then(user => {

            // create a token for created user
            const token = signToken(user);

            // return a token
            res.status(200).json({ token: token });
        })
    },

    signIn: async (req, res) => {
        console.log('UsersController.signIn() called');
    },

    secret: async (req, res) => {
        console.log('UsersController.secret() called');
    },
}