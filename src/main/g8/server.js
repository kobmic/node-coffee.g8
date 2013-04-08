require('coffee-script');

console.log("Starting server with:", process.env);

var app = require('./app')(function(){
    console.log("Server listening on port "+ app.get('port'))
});
