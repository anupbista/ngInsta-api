const { Post, Comment, User } = require('../db/sequilize')

module.exports = {
    getAllPosts: async (req, res) => {
        try {
            let posts = await Post.findAll();
            let allPosts = [];
            for (let post of posts) {
                post.comments = [];
                post.comments = await Comment.findAll({
                    where: { postId: post.id }
                }) 
                allPosts.push(postDTO(post)) 
            }
            console.log(allPosts)
            res.status(200).json(allPosts);
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
}

function postDTO(post){
    return {
        id: post.id,
        latitude: post.latitude,
        longitude: post.longitude,
        postImage: post.postImage,
        caption: post.caption,
        likesNo: post.likesNo,
        commentsNo: post.commentsNo,
        createdAt: post.createdAt,
        updatedAt: post.updatedAt,
        comments: []
      }
}