
path = require 'path'

module.exports = (app, static_route) ->
    #static_route is the path the the application static resources

    app.get '/', (req,res)->
        res.sendfile path.join static_route, 'index.html'

    return {}
    
