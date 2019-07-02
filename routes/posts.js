const router = require('express-promise-router')();
const passport = require('passport');
const multer = require('multer');
const path = require('path');

const PostsController = require('../controllers/posts.js');
const CommentsController = require('../controllers/comments.js');
const LikesController = require('../controllers/likes.js');
const passportJWT = passport.authenticate('jwt', {session: false});
const { postImageDir } = require('../config/config')

let storage = multer.diskStorage({
    destination: (req, file, cb) => {
      // cb(null,  path.join(__dirname, postImageDir));
      cb(null, postImageDir);
    },
    filename: (req, file, cb) => {
        let ext = file.originalname.split('.');
      cb(null, req.params.postId + '-' + Date.now() + '.' + ext[ext.length-1]);
    }
});

let upload = multer({storage: storage});

// Posts
router.route('/timeline/:userId/page/:page').get(passportJWT, PostsController.getAllPosts);

router.route('/explore/:page').get(passportJWT, PostsController.getExplorePosts);

router.route('/:id/page/:page').get(passportJWT, PostsController.getPostByUserId);

router.route('/:postId').get(passportJWT, PostsController.getPostByPostId);

router.route('/').post(passportJWT, PostsController.addNewPost);

router.route('/:id').delete(passportJWT, PostsController.deletePost);

router.route('/postimage/:postId').post(passportJWT, upload.single('postImage'), PostsController.savePostPicture);

// Comments
router.route('/:id/comments').get(passportJWT, CommentsController.getAllComments);

router.route('/comments').post(passportJWT, CommentsController.addNewComment);

// Likes
router.route('/:id/likes').get(passportJWT, LikesController.getAllLikes);

router.route('/likes').post(passportJWT, LikesController.addNewLike);

// unlike
router.route('/unlike').post(passportJWT, LikesController.unLike);

// getImage
router.route('/image/uploads/posts/:id').get(PostsController.getImage);

module.exports = router;