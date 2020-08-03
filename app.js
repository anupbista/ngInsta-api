const express = require('express');
const morgan = require('morgan');
const bodyParser = require('body-parser');
const cors = require('cors')
const socket = require('socket.io');
const app = express();
const http = require('http');
require('dotenv').config()

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
let activeUsers = [];
let server = http.createServer(app);
let io = socket.listen(server);
io.on('connection', socket => {
    console.log('Connection with socket');

    socket.on('user-connect', (userId) => {
        // push user to active users
        socket.userId = userId;
        activeUsers.push({
            userId: userId,
            socketId: socket.id
        })
        // io.emit("new-user-connect", userId);
         io.emit('user-status', activeUsers);
    });

    socket.on('user-disconnect', (userId) => {
        // remove user to active users
        activeUsers = [...activeUsers.filter( user => user.userId != userId)];
        socket.broadcast.emit('user-status',  activeUsers );
    });

    socket.on('user-status-request', (userId) => {
        let r__user = activeUsers.find( user => user.userId == userId);
        io.to(r__user.socketId).emit('user-status', activeUsers); 
    });

    socket.on('disconnect', () => {
         // remove user to active users
         activeUsers = [...activeUsers.filter( user => user.userId != socket.userId)];
         socket.broadcast.emit('user-status', activeUsers);
         socket.removeAllListeners();
    });

    socket.on('new-message', (data) => {
        let receiverUser = activeUsers.find( user => user.userId == data.receiver.id);
        let senderUser = activeUsers.find( user => user.userId == data.sender.id);
        // console.log(receiverUser);
        // console.log(senderUser)
        if(receiverUser && senderUser){
            io.to(senderUser.socketId).emit('new-message', {user: data.sender, message: data.message, receiverid: data.receiver.id}); 
            io.to(receiverUser.socketId).emit('new-message', {user: data.sender, message: data.message, receiverid: data.receiver.id}); 
        }
    })

})

// Start the server
const port = process.env.PORT || 3002;
server.listen(port, function() {
    console.log(`Sever listening at ${port}`);
} )