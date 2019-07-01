const router = require('express-promise-router')();
const passport = require('passport');
const multer = require('multer');
const path = require('path');

const passportConfig = require('../helpers/passport');
const UsersController = require('../controllers/users.js');
const NotificationController = require('../controllers/notification');
const passportJWT = passport.authenticate('jwt', {session: false});
const { profileImageDir } = require('../config/config')

let storage = multer.diskStorage({
    destination: (req, file, cb) => {
      // cb(null,  path.join(__dirname, profileImageDir));
      cb(null, profileImageDir);
    },
    filename: (req, file, cb) => {
        let ext = file.originalname.split('.');
      cb(null, req.params.userId + '-' + Date.now() + '.' + ext[ext.length-1]);
    }
});

let upload = multer({storage: storage});

// search user
router.route('/search').get(passportJWT, UsersController.searchUser);
// get current user by token
router.route('/:token').get(passportJWT, UsersController.getCurrentUserByToken);
// get user by username
router.route('/user/:username').get(passportJWT, UsersController.getCurrentUserByUsername);
// get profile
router.route('/profile/:userId').get(passportJWT, UsersController.getProfile);
// get user profile
router.route('/userprofile/:userId').get(passportJWT, UsersController.getUserProfile);
// get followers
router.route('/profile/:userId/followers/:page').get(passportJWT, UsersController.getFollowers);
// get following
router.route('/profile/:userId/following/:page').get(passportJWT, UsersController.getFollowing);
// save profile (put)
router.route('/profile/:userId').put(passportJWT, UsersController.saveProfile);
// save profilePicture
router.route('/profile/:userId/profileimage').post(passportJWT, upload.single('profileImage'), UsersController.saveProfilePicture);
// getImage
router.route('/image/uploads/profile/:id').get(UsersController.getImage);
// get Other Notifications
router.route('/othernotifications/:userId').get(passportJWT, NotificationController.getOtherNotifications);

module.exports = router;