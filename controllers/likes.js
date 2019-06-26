const { Likes, User } = require('../db/sequilize')

module.exports = {
    getAllLikes: async (req, res) => {
        try {
            const postId = req.params.id;
            const likes = await Likes.findAll( { where: { postId }, include: [{model: User, attributes: { exclude: ['password']}}]});
            const allLikes = [];
            likes.forEach( like => {
                allLikes.push(likesDTO(like.user));
            });
            res.status(200).json(allLikes);
        } catch (error) {
            res.status(500).json({
                message: error.message
            })
        }
    },

    addNewLike: async (req, res) => {
        try {
            const like = await Likes.create(req.body);
            res.status(200).json(like.id);
        } catch (error) {
            res.status(500).json({
                message: error
            })
        }
    },

    unLike: async (req, res) => {
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
function likesDTO(user){
    return {
        id: user.id,
        username: user.username,
        userImage: user.userImage,
        privateProfile: user.privateProfile,
        displayName: user.displayName,
      }
}