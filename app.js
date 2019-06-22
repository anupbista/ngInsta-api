const express = require('express');
const margan = require('morgan');
const bodyParser = require('body-parser');

const app = express();

// Middlewares
app.use(margan('dev'));
app.use(bodyParser.json());

// Routes
app.use('/users', require('./routes/users'));

// Start the server
const port = process.env.port || 3000;
app.listen(port, function() {
    console.log(`Sever listening at ${port}`);
} )