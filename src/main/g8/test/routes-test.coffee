mocha = require 'mocha'
chai = require 'chai'
should = chai.should()
expect = chai.expect
assert = chai.assert
sinon = require 'sinon'

request = require 'supertest'


describe "when testing routes", ->

    app =
    req = null


    beforeEach ->

        app = require('../app')()
        req = request app


    describe "GET /", ->

        it "should return 200", (done) ->
            req = req.get "/"
            req.expect 200, done

