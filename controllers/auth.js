const JWT = require('jsonwebtoken');

const { User, UserToken } = require('../db/sequilize')
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
        .then(async (user) => {

            // create a token for created user
            const token = signToken(user);
            await UserToken.create({
                userId: user.id,
                token: token
            })
            // return a token
            res.status(200).json({ token: token, expiresIn:  new Date().setDate( new Date().getDate() + 1 ), userId: user.id });
        }).catch(err => {
            res.status(500).json({
                message: error.message
            })
        })
    },

    signIn: async (req, res) => {
        console.log('UsersController.signIn() called');
       
        // check if user with the email exists
        const user = await User.findOne({ where: { email: req.body.email } })
        if(!user){
            return res.status(403).json({message: "No user with the email found."})
        }

        const token = signToken(req.user);
        await UserToken.create({
            userId: user.id,
            token: token
        })
        res.status(200).json({ 
            token: token,
            expiresIn:  new Date().setDate( new Date().getDate() + 1 ),
            userId: user.id  
        })

    }
}