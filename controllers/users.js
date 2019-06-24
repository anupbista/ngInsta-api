const { User } = require('../db/sequilize')

module.exports = {
    profile: async (req, res) => {        
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
}

function userDTO(user){
    return {
        id: user.id,
        username: user.name,
        email: user.email,
        userImage: user.userImage,
        privateProfile: user.privateProfile
      }
}