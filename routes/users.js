const router = require('express-promise-router')();
const passport = require('passport');

const passportConfig = require('../helpers/passport');
const UsersController = require('../controllers/users.js');
const passportJWT = passport.authenticate('jwt', {session: false});

router.route('/profile/:userId').get(passportJWT, UsersController.profile);

module.exports = router;