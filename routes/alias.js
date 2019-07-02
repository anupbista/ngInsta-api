const router = require('express-promise-router')();
const passport = require('passport');

const passportJWT = passport.authenticate('jwt', {session: false});
const AliasController = require('../controllers/alias');

// router.route('/').get(passportJWT, PostsController.getAllPosts);

router.route('/follow').post(passportJWT, AliasController.follow);

router.route('/unFollow').post(passportJWT, AliasController.unFollow);

router.route('/approvefollow').put(passportJWT, AliasController.approveFollow);

module.exports = router;