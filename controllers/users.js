const { Alias, User, UserToken, Notification, Sequelize } = require('../db/sequilize')
const Op = Sequelize.Op;
const path = require('path');
const { profileImageDir, defaultImageDir } = require('../config/config')

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

    getUserProfile: async (req, res) => {        
        console.log('UsersController.getUserProfile() called');
        try {
            const userId = req.params.userId;
            const id = req.query.id;
            const user = await Alias.findOne({ where: { userId: id, aliasId: userId } });
            res.status(200).json(user);
        } catch (error) {
            res.status(500).json({
                message: error
            })
        }
    },

    getCurrentUserByToken: async (req, res) => {        
        console.log('UsersController.getCurrentUser() called');
        try {
            const token = req.params.token;
            const userToken = await UserToken.findAll({ where: { token: token } });
            const user = await User.findOne({ where: { id: userToken[0].userId }, attributes: { exclude: ['password', 'phoneNumber']} });
            res.status(200).json(user);
        } catch (error) {
            res.status(500).json({
                message: error.message
            })
        }
    },

    getCurrentUserByUsername: async (req, res) => {        
        console.log('UsersController.getCurrentUser() called');
        try {
            const username = req.params.username;
            const user = await User.findOne({ where: { username: username }, attributes: { exclude: ['password', 'phoneNumber']} });
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

            let followedUsers = await Alias.findAll( { attributes: ['aliasId'], where: { aliasId: userId, followRequested: { [Op.ne]: true} }, limit: limit, offset: offset, include: [ {model: User, attributes: { exclude: ['password']}} ] });
            for (const user of followedUsers) {
                const status = await Alias.findOne( { attributes: ['id', 'followRequested'], where: { userId: userId, aliasId: user.user.id } } );
                user.user.setDataValue('status', status)
            }
            res.status(200).json(followedUsers);
        } catch (error) {
            res.status(500).json({
                message: error.message
            })
        }
    },

    getFollowing: async (req, res) => {        
        console.log('UsersController.getFollowing() called');
        try {
            let limit = 10;
            let page = req.params.page;
            let offset = limit * (page - 1);
            const userId = req.params.userId;

            // select following user only
            let followingUsers = await Alias.findAll( { attributes: ['aliasId'], where: { userId: userId, followRequested: { [Op.ne]: true} } });
            let aliasIds = [];
            followingUsers.forEach(element => {
                aliasIds.push(element.aliasId)
            });

            let users = await User.findAll({ where: { id: aliasIds },limit: limit, offset: offset });
            for (const user of users) {
                const status = await Alias.findOne( { attributes: ['id', 'followRequested'], where: { userId: userId, aliasId: user.id } } );
                user.setDataValue('status', status)
            }
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
            const limit = 5;
            let users = []; 
            if(searchText != ""){
                users = await User.findAll({ attributes: ['username','displayName','userImage',], where: {
                    [Op.or]: [ {username: { [Op.like]: "%"+ searchText +"%" }}, {displayName: { [Op.like]: "%"+ searchText +"%" }} ]
                 }, limit: limit, order: [['updatedAt', 'DESC']] });
            }else{
                users = []
            }
            res.status(200).json(users);
        } catch (error) {
            res.status(500).json({
                message: error.message
            })
        }
    },
    
    getImage: (req, res) => {
        res.sendFile(path.join(__dirname +"../../"+profileImageDir+"/"+req.params.id ));
    },

    getUserSuggestions: async (req, res) => {
        try {
            const userId = req.params.userId;
            let limit = 3;
            let suggestions = await User.findAll({ order: Sequelize.literal('random()'), limit: limit, where: { id: { [Op.ne]: userId}}});
            let tempSuggestion = suggestions.slice();
            for (let index = 0; index < tempSuggestion.length; index++) {
                const follow = await Alias.findOne({
                    where: { userId: userId, aliasId: tempSuggestion[index].id  }
                });
                if(follow){
                    let index = suggestions.findIndex( i => {
                        return i.id === follow.aliasId;
                    });
                   suggestions.splice(index, 1);
                }
            }
            res.status(200).json(suggestions);
        } catch (error) {
            res.status(500).json({
                message: error.message
            })
        }
    },

    updateNotification: async (req, res) => {        
        try {
            const ids = req.body.ids;
            await Notification.update({
                status: true
            }, { where: {id: ids}, returning: true, plain: true})
            res.status(200).json(ids);
        } catch (error) {
            res.status(500).json({
                message: error
            })
        }
    },

    addPushSubscriber: async (req, res) => {        
        try {
            const userId = req.params.userId;
            const sub = JSON.stringify(req.body.sub);
            await User.update({
                notification_subs: sub
            }, { where: {id: userId} })
            res.status(200).json(userId);
        } catch (error) {
            res.status(500).json({
                message: error
            })
        }
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