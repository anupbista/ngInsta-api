const { User, Alias } = require('../db/sequilize')

module.exports = {
    follow: async (req, res) => {
        try {
            let aliasId = req.body.aliasId;
            const user = await User.findOne({ where: { id: aliasId }, raw: true,  attributes: ['privateProfile'] });
            if(user.privateProfile){
                // if private profile
                await Alias.create({
                    "userId": req.body.userId,
                    "aliasId": req.body.aliasId,
                    "followRequested": true
                });
            }else{
                await Alias.create(req.body);
            }
            res.status(200).json(true);
        } catch (error) {
            console.log(error)
            res.status(500).json({
                message: error.message
            })
        }
    },

    unFollow: async (req, res) => {
        try {
            let userId = req.body.userId;
            let aliasId = req.body.aliasId;
            await Alias.destroy({
                where: { userId: userId, aliasId: aliasId }
            });
            res.status(200).json(true);
        } catch (error) {
            res.status(500).json({
                message: error.message
            })
        }
    },

    approveFollow: async (req, res) => {
        try {
            let userId = req.body.userId;
            let aliasId = req.body.aliasId;
            await Alias.update( { followRequested: 0 }, { where: {userId: userId, aliasId: aliasId}, returning: true, plain: true})
            res.status(200).json(true);
        } catch (error) {
            res.status(500).json({
                message: error.message
            })
        }
    }
}