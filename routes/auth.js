const router = require('express-promise-router')();
const passport = require('passport');

const passportConfig = require('../helpers/passport');
const AuthController = require('../controllers/auth.js');
const passportSignIn = passport.authenticate('local', {session: false});

// router.route('/signup').post(validateBody(schemas.authSchema), UsersController.signUp);
router.route('/signup').post(AuthController.signUp);

router.route('/signin').post(passportSignIn ,AuthController.signIn);

// router.route('/oauth/facebook').post(passport.authenticate('facebookStrategy', {session: false}), UsersController.secret);

module.exports = router;