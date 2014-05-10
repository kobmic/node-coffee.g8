express = require 'express'
path = require 'path'
socketio = require 'socket.io'

module.exports = () ->
    app = express()

    module.exports.static_route
    app.configure ->
        app.set('port', process.env.PORT || 8080);
        app.use(express.favicon())
        app.use(express.methodOverride())
        app.use(express.bodyParser());
        app.use(express.limit('2mb'));

    app.configure 'development', ->
        app.use express.logger({ format: 'short' })
        app.use express.errorHandler()

    app.configure 'test', ->
        app.use express.errorHandler()

    app.configure ->
        module.exports.static_route = path.join __dirname, 'public'
        app.use(express.static(path.join(__dirname, 'public')))

        #app.set('views', __dirname + '/public/views')
        app.use(app.router)

        # use hogan express
        #app.set 'view engine', 'html'
        #app.engine 'html', require('hogan-express')
        #app.set('layout', 'layout')
        #app.set('partials', head: "head")


    #Init Routes
    require('./routes')(app, module.exports.static_route)

    http = require 'http'
    server = http.createServer app
    server.listen app.get('port'), () ->
        console.log("Server listening on port "+ app.get('port'))
    app


    