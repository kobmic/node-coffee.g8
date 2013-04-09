mocha = require 'mocha'
chai = require 'chai'
should = chai.should()
expect = chai.expect
assert = chai.assert
sinon = require 'sinon'

request = require 'supertest'


describe "sample integration test", ->

    app =
        req = null


    beforeEach ->

        app = require('../app')()
        req = request app


    describe "do some database stuff", ->

        it "should work", (done) ->
            expect(true).to.be.true
            done()


