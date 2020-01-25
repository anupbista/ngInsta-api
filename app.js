const express = require('express');
const morgan = require('morgan');
const bodyParser = require('body-parser');
const cors = require('cors')
const socket = require('socket.io');
const app = express();
const http = require('http');

// Middlewares
app.use(cors());
app.use(morgan('dev'));
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

// Attach the socket to the http server
let server = http.createServer(app);
socket.listen(server);
let io = socket(server);
io.on('connection', socket => {
    console.log('Connection with socket');

    socket.on('new-message', (data) => {
        io.emit('new-message', {user: data.user, message: data.message})
    })

})

// Start the server
const port = process.env.PORT || 3002;
server.listen(port, function() {
    console.log(`Sever listening at ${port}`);
} )