const passport = require('passport')
const JWTStrategy = require('passport-jwt').Strategy
const LocalStrategy = require('passport-local').Strategy
const { ExtractJwt } = require('passport-jwt')

const { JWT_SECRET } = require('../config/config')
const { User } = require('../db/sequilize')

// JWT Strategy
passport.use(new JWTStrategy({
    jwtFromRequest: ExtractJwt.fromHeader('authorization'),
    secretOrKey: JWT_SECRET
}, async (payload, done) => {
    try {
        // find the user specified in token
        const user = await User.findAll({
            where: {
               id: payload.sub
            }
         })
        // if user doesnot exists, handle it
        if(!user){
            return done(null, false)
        }
        // otherwise, return the user
        done(null, user)
    } catch (error) {
        done(error, false)
    }
}));

// LocalStrategy
passport.use(new LocalStrategy({
    usernameField: 'email',
}, async (email, password, done) => {
    try {
        // find the user specified in email
        const user = await User.findAll({
            where: {
               email: email
            }
         })
        // if user doesnot exists, handle it
        if(!user){
            return done(null, false)
        }
        // check if password is correct

        // if password is not correct, handle it
        
        // otherwise, return the user
        done(null, user)
    } catch (error) {
        done(error, false)
    }
}));