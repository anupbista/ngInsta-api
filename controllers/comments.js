const { Comment } = require('../db/sequilize')

module.exports = {
    getAllComments: async (req, res) => {
        try {
            const postId = req.params.id;
            const comments = await Comment.findAll( { where: { postId }});
            res.status(200).json(comments);
        } catch (error) {
            res.status(500).json({
                message: error.message
            })
        }
    },
    addNewComment: async (req, res) => {
        try {
            const comment = await Comment.create(req.body);
            res.status(200).json(comment.id);
        } catch (error) {
            res.status(500).json({
                message: error.message
            })
        }
    },
}