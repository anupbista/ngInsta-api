const JWT = require('jsonwebtoken');

module.exports = {

    verifyToken: (req, res, next) => {
        var token = req.headers['Authorization'];
        if (!token)
          return res.status(403).send({ auth: false, message: 'No token provided.' });
          
          JWT.verify(token, process.env.JWT_SECRET, (err, decoded) => {
          if (err)
          return res.status(500).send({ auth: false, message: 'Failed to authenticate token.' });
            
          // if everything good, save to request for use in other routes
          req.userId = decoded.id;
          next();
        });
    }

};