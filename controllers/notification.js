const { Notification, User, Post } = require('../db/sequilize')

module.exports = {
    getOtherNotifications: async (req, res) => {
        try {
            const userId = req.params.userId;
            const otherNotifications = await Notification.findAll( { where: { aliasId: userId }, include: [{model: User, attributes: { exclude: ['password']}}, {model: Post}]});
            res.status(200).json(otherNotifications);
        } catch (error) {
            res.status(500).json({
                message: error.message
            })
        }
    },

    getRequestNotifications: async (req, res) => {
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
    }
}