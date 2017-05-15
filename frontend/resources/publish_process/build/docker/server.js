/*
 This server meant to change api server address dynamically even after the Vue SPA bundled.
 I think the better way is just make sure api server is "example.com/api", then let the reverse proxy server handle it...
 */

var path = require('path')
var express = require('express')
var app = express()

app.use(express.static('./'))

app.use('/', function ( req, res, next ) {
  res.sendfile(__dirname + '/index.html');
});

app.listen(3000, function () {
  console.log('customer_web started!')
})
