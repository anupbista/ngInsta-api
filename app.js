const express = require('express');
const margan = require('morgan');
const bodyParser = require('body-parser');
const cors = require('cors')

const app = express();

// Middlewares
app.use(cors());
app.use(margan('dev'));
app.use(bodyParser.json());

// Routes
// Auth
app.use('/auth', require('./routes/auth'));

// Users
app.use('/user', require('./routes/users'));

// Posts
app.use('/posts', require('./routes/posts'));

// Start the server
const port = process.env.port || 3000;
app.listen(port, function() {
    console.log(`Sever listening at ${port}`);
} )