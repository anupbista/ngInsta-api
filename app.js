const express = require('express');
const margan = require('morgan');
const bodyParser = require('body-parser');
const cors = require('cors')

const app = express();

// Middlewares
app.use(cors());
app.use(margan('dev'));
app.use(bodyParser.json({limit: '5mb'}));

// Routes
// Auth
app.use('/auth', require('./routes/auth'));

// Users
app.use('/user', require('./routes/users'));

// Posts
app.use('/posts', require('./routes/posts'));

// Posts
app.use('/alias', require('./routes/alias'));

// Start the server
const port = process.env.port || 8080;
app.listen(port, function() {
    console.log(`Sever listening at ${port}`);
} )