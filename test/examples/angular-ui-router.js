// Environment
var port= 59798;

// Dependencies
var express= require('express');
var turnout= require('../../');

// Setup express
var app= express();
app.use(turnout());
app.use(function(req, res) {
  res.sendFile(__dirname + '/angular-ui-router.html');
});

// Boot
app.listen(port, function() {
  console.log('listening at %s', port);
});