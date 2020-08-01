const { Post, Alias, User, Likes, Comment, SavedPosts, Sequelize } = require('../db/sequilize')
const Op = Sequelize.Op
const path = require('path');
const { cloudinary } = require('../config/cloudinary');

module.exports = {
    getAllPosts: async (req, res) => {
        try {
            let limit = 10;
            let userId = req.params.userId
            let page = req.params.page;
            let data = await Post.findAndCountAll();
            let pages = Math.ceil(data.count / limit);
            let offset = limit * (page - 1);

            // select followed user only
            let followedUsers = await Alias.findAll( { attributes: ['aliasId'], where: { userId: userId, followRequested: { [Op.ne]: true} } });
            let aliasIds = [];
            followedUsers.forEach(element => {
                aliasIds.push(element.aliasId)
            });
            // get posts from followed users
            let posts = await Post.findAll({ order: [['createdAt', 'DESC']], where: { userId: aliasIds },limit: limit, offset: offset, include: [ {model: User, attributes: { exclude: ['password']}}, {model: Likes, attributes: ['userId']}, { model: SavedPosts, attributes: ['userId'] } ] });
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

            let posts = await Post.findAll({ where: { userId: { [Op.ne]: userId}}, limit: limit, offset: offset, include: [ {model: User, where: { privateProfile: { [Op.ne]: true}}, attributes: ['username', 'id']} ] });

            let tempPosts = posts.slice();
            for (let index = 0; index < tempPosts.length; index++) {
                const follow = await Alias.findOne({
                    where: { userId: userId, aliasId: tempPosts[index].userId  }
                });
                if(follow){
                    let index = posts.findIndex( i => {
                        return i.userId === follow.aliasId;
                    });
                    posts.splice(index, 1);
                }
            }

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
            
            let post = await Post.findOne({ order:[ [{model: Comment}, "createdAt", "ASC"] ], where: { id: postId }, include: [ {model: User, attributes: ['id','username', 'displayName', 'userImage'] }, {model: Likes, attributes: ['userId', 'createdAt'], include: [ {model: User, attributes: ['id','username', 'displayName', 'userImage']} ]}, { model: Comment, attributes: ['userId', 'createdAt', 'commentText'], include: [ {model: User, attributes: ['id','username', 'displayName', 'userImage']} ] }, { model: SavedPosts, attributes: ['userId'] } ] });
          
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
            if (req.file) {
                const postId = req.params.postId;
                const image = await cloudinary.uploader.upload(req.file.path, { tags: 'post_image', folder: 'posts' })
                await Post.update({ postImage: image.url }, { where: { id: postId } })
                res.status(200).json({
                    url: image.url
                })
            } else {
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
        res.sendFile(path.join(__dirname +"../../"+process.env.postImageDir+"/"+req.params.id ));
    },

    getAllSavedPostsByUserId: async (req, res) => {
        try {
            const userId = req.params.userId;
            let limit = 9;
            let page = req.params.page;
            let offset = limit * (page - 1);
            let posts = await SavedPosts.findAll({ order: [['createdAt', 'DESC']], where: { userId: userId }, limit: limit, offset: offset, include: [ {model: Post } ] });
            res.status(200).json(posts);
        } catch (error) {
            res.status(500).json({
                message: error.message
            })
        }
    },

    addToSavedPosts: async (req, res) => {
        try {
            const savePost = await SavedPosts.create(req.body);
            res.status(200).json(savePost.id);
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
            await SavedPosts.destroy({
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