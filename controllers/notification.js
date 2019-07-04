const { Notification, User, Post, Sequelize } = require('../db/sequilize')
const Op = Sequelize.Op;

module.exports = {
    getOtherNotifications: async (req, res) => {
        try {
            let limit = 8;
            let page = req.params.page;
            let offset = limit * (page - 1);
            const userId = req.params.userId;
            const otherNotifications = await Notification.findAll( { limit: limit, offset: offset, where: { aliasId: userId, type: { [Op.like]: "other-%" } }, include: [{model: User, attributes: { exclude: ['password']}}, {model: Post}]});
            res.status(200).json(otherNotifications);
        } catch (error) {
            res.status(500).json({
                message: error.message
            })
        }
    },

    getFollowNotifications: async (req, res) => {
        try {
            const userId = req.params.userId;
            const followNotifications = await Notification.findAll( { where: { aliasId: userId, type: { [Op.like]: "follow%" }  }, include: [{model: User, attributes: { exclude: ['password']}}]});
            res.status(200).json(followNotifications);
        } catch (error) {
            res.status(500).json({
                message: error.message
            })
        }
    }

    // getRequestNotifications: async (req, res) => {
    //     try {
    //         const postId = req.params.id;
    //         const likes = await Likes.findAll( { where: { postId }, include: [{model: User, attributes: { exclude: ['password']}}]});
    //         const allLikes = [];
    //         likes.forEach( like => {
    //             allLikes.push(likesDTO(like.user));
    //         });
    //         res.status(200).json(allLikes);
    //     } catch (error) {
    //         res.status(500).json({
    //             message: error.message
    //         })
    //     }
    // }
}