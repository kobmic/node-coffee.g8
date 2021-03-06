express = require 'express'
path = require 'path'
favicon = require 'serve-favicon'
logger = require 'morgan'
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'
https = require 'https'
http = require 'http'

routes = require './routes/index'
users = require './routes/users'

app = express()

# set max socket connections
https.globalAgent.maxSockets = 1000
http.globalAgent.maxSockets = 1000


# view engine setup
app.set('views', path.join(__dirname, 'public/views'))
app.set 'view engine', 'html'
app.engine 'html', require('hogan-express')
app.engine 'xml', require('hogan-express')

# uncomment after placing your favicon in /public
#app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));

app.use(bodyParser.json())
app.use(bodyParser.urlencoded({ extended: false }))
app.use(cookieParser())

if ('production' == process.env.NODE_ENV)
    # production config
    app.use(logger(':req[x-forwarded-for] - - [:date] ":method :url HTTP/:http-version" :status :res[content-length] ":referrer" ":user-agent" :response-time ms'))
    app.use(express.static(path.join(__dirname, 'static/release')))
else
    # development config
    app.use(logger('dev'))
    app.use(express.static(path.join(__dirname, 'static/debug')))


# routes
app.use('/', routes)
app.use('/users', users)

# catch 404 and forward to error handler
app.use (req, res, next) ->
    err = new Error('Not Found')
    err.status = 404
    next(err)

#
# error handlers
#

# development error handler
# will print stacktrace
if (app.get('env') == 'development')
    app.use (err, req, res, next) ->
        res.status(err.status || 500)
        res.render('error', { message: err.message, error: err})

# production error handler
# no stacktraces leaked to user
app.use (err, req, res, next) ->
    res.status(err.status || 500)
    res.render('error', { message: err.message, error: {} })


module.exports = app
