express = require 'express'
path = require 'path'
socketio = require 'socket.io'

module.exports = (initFn)->
    # initFn is a function the do init the application
    app = express()

    module.exports.static_route
    app.configure ->
        app.set('port', process.env.PORT || 8080);
        app.use(express.favicon())
        #Not used inteferce with binary uploads app.use(express.bodyParser())
        app.use(express.methodOverride())
        app.use(express.limit('2mb'));

    app.configure 'development', ->
        app.use express.logger({ format: 'short' })
        app.use express.errorHandler()

    app.configure 'test', ->
        app.use express.errorHandler()

    app.configure ->
        app.use(app.router)

    app.configure 'production', ->
        module.exports.static_route = path.join __dirname, 'build/release'
        oneYear = 1000*60*60*24*365
        app.use(express.static(path.join(__dirname, 'build/release'),{ maxAge: oneYear }))

    app.configure 'test', ->
        module.exports.static_route = path.join __dirname, 'build/debug'
        app.use(express.static(path.join(__dirname, 'build/debug')))

    app.configure 'development', ->
        module.exports.static_route = path.join __dirname, 'build/debug'
        app.use(express.static(path.join(__dirname, 'build/debug')))

    #Init Routes
    require('./routes')(app, module.exports.static_route)



    if initFn?
        http = require 'http'
        server = http.createServer app
        io = require('socket.io').listen server

        io.set 'transports', ['websocket']

        app.configure 'test', -> io.set 'log level',0

        server.listen app.get('port'), initFn


    app


    