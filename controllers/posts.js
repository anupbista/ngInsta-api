const { Post, Alias, User, Likes, Comment, Sequelize } = require('../db/sequilize')
const Op = Sequelize.Op
const path = require('path');
const { postImageDir } = require('../config/config')

module.exports = {
    getAllPosts: async (req, res) => {
        try {
            let limit = 2;
            let userId = req.params.userId
            let page = req.params.page;
            let data = await Post.findAndCountAll();
            let pages = Math.ceil(data.count / limit);
            let offset = limit * (page - 1);

            // select followed user only
            let followedUsers = await Alias.findAll( { attributes: ['aliasId'], where: { userId: userId, followRequested: { [Op.ne]: 1} } });
            let aliasIds = [];
            followedUsers.forEach(element => {
                aliasIds.push(element.aliasId)
            });
            // get posts from followed users
            let posts = await Post.findAll({ order: [['createdAt', 'DESC']], where: { userId: aliasIds },limit: limit, offset: offset, include: [ {model: User, attributes: { exclude: ['password']}}, {model: Likes, attributes: ['userId']} ] });
            res.status(200).json(posts);
        } catch (error) {
            res.status(500).json({
                message: error.message
            })
        }
    },

    getExplorePosts: async (req, res) => {
        try {
            const userId = req.params.userId;
            let limit = 20;
            let page = req.params.page;
            let data = await Post.findAndCountAll();
            let pages = Math.ceil(data.count / limit);
            let offset = limit * (page - 1);

            // get posts from followed users
            let posts = await Post.findAll({ order: [ Sequelize.fn( 'RAND' )], where: { userId: { [Op.ne]: userId}}, limit: limit, offset: offset, include: [ {model: User, where: { privateProfile: { [Op.ne]: 1}}, attributes: ['username', 'id']} ] });

            // for (const post of posts) {
            //     const status = await Alias.findOne( { attributes: ['id', 'followRequested'], where: { userId: userId, aliasId: post.user.id } } );
            //     post.setDataValue('status', status)
            // }

            res.status(200).json(posts);
        } catch (error) {
            res.status(500).json({
                message: error.message
            })
        }
    },

    getPostByUserId: async (req, res) => {
        try {
            const userId = req.params.id;
            const profile = req.query.profile;
            let limit = 9;
            let page = req.params.page;
            let data = await Post.findAndCountAll();
            let pages = Math.ceil(data.count / limit);
            let offset = limit * (page - 1);    
            let posts = [];
            if(profile == "true"){
                posts = await Post.findAll({ order: [['createdAt', 'DESC']], where: { userId: userId }, limit: limit, offset: offset, include: [ {model: User, attributes: { exclude: ['password']}} ] });
            }else{
                posts = await Post.findAll({ order: [['createdAt', 'DESC']], where: { userId: userId }, limit: limit, offset: offset, include: [ {model: User, attributes: { exclude: ['password']}} ] });
            }
            res.status(200).json(posts);
        } catch (error) {
            res.status(500).json({
                message: error.message
            })
        }
    },

    getPostByPostId: async (req, res) => {
        try {
            const postId = req.params.postId;
            
            let post = await Post.findOne({ order:[ [{model: Comment}, "createdAt", "ASC"] ], where: { id: postId }, include: [ {model: User, attributes: ['id','username', 'displayName', 'userImage'] }, {model: Likes, attributes: ['userId', 'createdAt'], include: [ {model: User, attributes: ['id','username', 'displayName', 'userImage']} ]}, { model: Comment, attributes: ['userId', 'createdAt', 'commentText'], include: [ {model: User, attributes: ['id','username', 'displayName', 'userImage']} ] } ] });
          
            res.status(200).json(post);

        } catch (error) {
            res.status(500).json({
                message: error.message
            })
        }
    },

    addNewPost: async (req, res) => {
        try {
            const post = await Post.create(req.body);
            res.status(200).json(post.id);
        } catch (error) {
            res.status(500).json({
                message: error.message
            })
        }
    },

    deletePost: async (req, res) => {
        try {
            const postId = req.params.id;
            await Post.destroy({
                where: { id: postId }
            });
            res.status(200).json(true);
        } catch (error) {
            res.status(500).json({
                message: error.message
            })
        }
    },

    savePostPicture: async (req, res) => {
        try {
            console.log(req.file);
            if(req.file){
                const postId = req.params.postId;
                const image = await Post.update({ postImage: req.file.path }, { where: {id: postId}})
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

    getImage: (req, res) => {
        res.sendFile(path.join(__dirname +"../../"+postImageDir+"/"+req.params.id ));
    },

    getAllSavedPosts: async (req, res) => {
        try {
            const postId = req.params.id;
            const userId = req.params.userId;
            const likes = await Likes.findAll( { where: { postId }, include: [{model: User, attributes: [ 'id', 'username', 'displayName', 'userImage' ]}]});
            for (const like of likes) {
                const status = await Alias.findOne( { attributes: ['id', 'followRequested'], where: { userId: like.userId, aliasId: userId } } );   
                like.setDataValue('status', status);
            }
            res.status(200).json(likes);
        } catch (error) {
            res.status(500).json({
                message: error.message
            })
        }
    },

    addToSavedPosts: async (req, res) => {
        try {
            const like = await Likes.create(req.body);
            res.status(200).json(like.id);
        } catch (error) {
            res.status(500).json({
                message: error
            })
        }
    },

    unSavePost: async (req, res) => {
        try {
            let userId = req.body.userId;
            let postId = req.body.postId;
            await Likes.destroy({
                where: { userId: userId, postId: postId }
            });
            res.status(200).json(true);
        } catch (error) {
            res.status(500).json({
                message: error
            })
        }
    }
}