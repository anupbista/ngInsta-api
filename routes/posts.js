const router = require('express-promise-router')();
const passport = require('passport');

const PostsController = require('../controllers/posts.js');
const CommentsController = require('../controllers/comments.js');
const passportJWT = passport.authenticate('jwt', {session: false});

// Posts
router.route('/').get(passportJWT, PostsController.getAllPosts);

router.route('/').post(passportJWT, PostsController.addNewPost);

// Comments
router.route('/:id/comments').get(passportJWT, CommentsController.getAllComments);

router.route('/comments').post(passportJWT, CommentsController.addNewComment);

module.exports = router;