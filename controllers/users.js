const { Alias, User, UserToken, Sequelize } = require('../db/sequilize')
const Op = Sequelize.Op;
const path = require('path');
const { profileImageDir } = require('../config/config')

module.exports = {
    getProfile: async (req, res) => {        
        console.log('UsersController.profile() called');
        try {
            const userId = req.params.userId;
            const user = await User.findOne({ where: { id: userId } });
            res.status(200).json(userDTO(user));
        } catch (error) {
            res.status(500).json({
                message: error
            })
        }
    },

    getCurrentUser: async (req, res) => {        
        console.log('UsersController.getCurrentUser() called');
        try {
            const token = req.params.token;
            const userToken = await UserToken.findOne({ where: { token: token } });
            const user = await User.findOne({ where: { id: userToken.userId }, attributes: { exclude: ['password', 'phoneNumber']} });
            res.status(200).json(user);
        } catch (error) {
            res.status(500).json({
                message: error.message
            })
        }
    },

    getFollowers: async (req, res) => {        
        console.log('UsersController.getFollowers() called');
        try {
            let limit = 10;
            let page = req.params.page;
            let offset = limit * (page - 1);
            const userId = req.params.userId;

            let followedUsers = await Alias.findAll( { attributes: ['aliasId'], where: { aliasId: userId, followRequested: { [Op.ne]: 1} }, limit: limit, offset: offset, include: [ {model: User, attributes: { exclude: ['password']}} ] });
            for (const user of followedUsers) {
                const status = await Alias.findOne( { attributes: ['id'], where: { userId: userId, aliasId: user.user.id } } );
                user.user.setDataValue('status', status)
            }
            res.status(200).json(followedUsers);
        } catch (error) {
            res.status(500).json({
                message: error.message
            })
        }
    },

// TODO: get following
    getFollowing: async (req, res) => {        
        console.log('UsersController.getFollowing() called');
        try {
            let limit = 10;
            let page = req.params.page;
            let offset = limit * (page - 1);
            const userId = req.params.userId;

            // select following user only
            let followingUsers = await Alias.findAll( { attributes: ['aliasId'], where: { userId: userId, followRequested: { [Op.ne]: 1} } });
            let aliasIds = [];
            followingUsers.forEach(element => {
                aliasIds.push(element.aliasId)
            });
            // get posts from followed users
            let users = await User.findAll({ where: { id: aliasIds },limit: limit, offset: offset });

            res.status(200).json(users);
        } catch (error) {
            res.status(500).json({
                message: error
            })
        }
    },

    saveProfile: async (req, res) => {        
        console.log('UsersController.saveProfile() called');
        try {
            const userId = req.params.userId;
            // save user's profile
            await User.update(req.body, { where: {id: userId}, returning: true, plain: true})
            const user = await User.findOne({ where: { id: userId } })
            res.status(200).json(user.id);
        } catch (error) {
            res.status(500).json({
                message: error
            })
        }
    },

    saveProfilePicture: async (req, res) => {
        try {
            console.log(req.file);
            if(req.file){
                const userId = req.params.userId;
                const image = await User.update({ userImage: req.file.path }, { where: {id: userId}})
                res.status(200).json(image[0] === 1 ? true : false)
            }else{
                res.status(500).json({
                    message: "Uploading failed."
                })
            }
            
        } catch (error) {
            res.status(500).json({
                message: error
            })
        }
    },

    searchUser: async (req, res) => {        
        console.log('UsersController.profile() called');
        try {
            const searchText = req.query.text;
            const users = await User.findAll({ attributes: ['username','displayName','userImage',], where: {
                [Op.or]: [ {username: { [Op.like]: "%"+ searchText +"%" }}, {displayName: { [Op.like]: "%"+ searchText +"%" }} ]
             }});
            res.status(200).json(users);
        } catch (error) {
            res.status(500).json({
                message: error.message
            })
        }
    },
    getImage: (req, res) => {
        res.sendFile(path.join(__dirname +"../../"+profileImageDir+"/"+req.params.id ));
    }
}

function userDTO(user){
    return {
        id: user.id,
        username: user.username,
        email: user.email,
        userImage: user.userImage,
        privateProfile: user.privateProfile,
        displayName: user.displayName,
        bio: user.bio,
        website: user.website,
        gender: user.gender,
        phoneNumber: user.phoneNumber,
        noOfPosts: user.noOfPosts,
        followers: user.followers,
        following: user.following
      }
}