const passport = require('passport')
const JWTStrategy = require('passport-jwt').Strategy
const LocalStrategy = require('passport-local').Strategy
const { ExtractJwt } = require('passport-jwt')

const { User } = require('../db/sequilize')

// JWT Strategy
passport.use(new JWTStrategy({
    jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
    secretOrKey: process.env.JWT_SECRET
}, async (payload, done) => {
    try {
        // find the user specified in token
        const user = await User.findAll({
            where: {
               id: payload.sub
            }
         })
        // if user doesnot exists, handle it
        if(!user[0]){
            return done(null, false)
        }
        // otherwise, return the user
        done(null, user[0])
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
        if(!user[0]){
            return done(null, false)
        }
        // if password is not correct, handle it
        const isValid = await user[0].isValidPassword(password);
        if(!isValid){
            return done(null, false);
        }
        // otherwise, return the user
        done(null, user[0])
    } catch (error) {
        done(error, false)
    }
}));

// Facebook Strategy
// passport.use('facebookStrategy', new FacebookStrategy({
//     clientID: config.oauth.facebook.clientID,
//     clientSecret: config.oauth.facebook.clientSecret
// }, async (accessToken, refreshToken, profile, done) => {
//     try {
//         console.log('profile', profile);
//         console.log('accessToken', accessToken);
//         console.log('refreshToken', refreshToken);
//     } catch (error) {
//         done(error, false, error.message)
//     }
// }))