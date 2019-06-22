const express = require('express');
const router = require('express-promise-router')();
// const router = express.Router();
const passport = require('passport');

const { validateBody, schemas} = require('../helpers/route-helper');
const UsersController = require('../controllers/users.js');
const passportConfig = require('../helpers/passport');

// router.route('/signup').post(validateBody(schemas.authSchema), UsersController.signUp);
router.route('/signup').post(UsersController.signUp);

router.route('/signin').post(UsersController.signIn);

router.route('/secret').get(passport.authenticate('jwt', {session: false}) ,UsersController.secret);

module.exports = router;