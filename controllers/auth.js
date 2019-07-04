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
        let user = await User.findOne({ where: { email: req.body.email } })
        if(user){
            return res.status(403).json({message: "User with the email already exists."})
        }
        user = await User.findOne({ where: { username: req.body.username } })
        if(user){
            return res.status(403).json({message: "User with the username already exists."})
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
        }).catch(error => {
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
    },

    signout: async (req, res) => {
        console.log('UsersController.signout() called');
        try {
            const token = req.body.token;
            // check if user with the email exists
            const user = await UserToken.findOne({ where: { token: token } })
            if(!user){
                return res.status(401).json({message: "Invalid user"})
            }
            await UserToken.destroy({
                where: { token: token, userId: user.userId }
            });
            res.status(200).json({message: "Successfully signout." })
        } catch (error) {
            return res.status(500).json({message: error.message })
        }

        // res.status(200).json({ 
        //     token: token,
        //     expiresIn:  new Date().setDate( new Date().getDate() + 1 ),
        //     userId: user.id  
        // })
    }

}