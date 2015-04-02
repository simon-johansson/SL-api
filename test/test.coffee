
{ expect } = require 'chai'
sinon      = require 'sinon'
nock       = require 'nock'
isJSON     = require 'is-json'
request    = require 'request'

SL = require '../lib/'

###
* Test promises
* Test chaning promises (using mocks? nock.js?)
* Test specifying format 'JSON' and 'XML'
* Test att url:en är rätt
* Test att request kastar en error
###

keys =
  realtimeInformation: 'xxx'
  locationLookup: 'xxx'
  tripPlanner: 'xxx'
  trafficSituation: 'xxx'
  disturbanceInformation: 'xxx'

describe 'SL (Storstockholms Lokaltrafik) API Wrapper\n', ()->

  it "should be able to instantiate if valid key name(s) is supplied", ->
    expect( -> new SL {realtimeInformation: "xxx"} ).to.not.throw Error
    expect( -> new SL {tripPlanner: "xxx", locationLookup: 'yyy'} ).to.not.throw Error
    expect( -> new SL keys ).to.not.throw Error

  it "should be able to specify json or xml response format", ->
    expect( -> new SL keys, 'xml' ).to.not.throw Error
    expect( -> new SL keys, 'XML' ).to.not.throw Error
    expect( -> new SL keys, 'json' ).to.not.throw Error
    expect( -> new SL keys, 'JSON' ).to.not.throw Error

  it "should throw error if no key is supplied", ->
    expect( -> new SL() ).to.throw /One of the following API keys have to be supplied/

  it "should throw error if supplied keys is not an object", ->
    expect( -> new SL("string") ).to.throw /The supplied API key\(s\) has to be an object/
    expect( -> new SL(123) ).to.throw /The supplied API key\(s\) has to be an object/

  it "should throw error if invalid keyname is supplied", ->
    invalidKeyNameSupplied = -> new SL({realtimeInformation: "xxx", wrongKeyName: "xxx"})
    expect( invalidKeyNameSupplied ).to.throw /The supplied key (.*) should be one of the following/

  it "should throw error if invalid response format is supplied", ->
    expect( -> new SL({realtimeInformation: "xxx"}, "txt") ).to.throw /(.*) which you supplied is not supported./
    expect( -> new SL({realtimeInformation: "xxx"}, 123) ).to.throw /(.*) which you supplied is not supported./
    expect( -> new SL({realtimeInformation: "xxx"}, {}) ).to.throw /(.*) which you supplied is not supported./

  it 'should throw error if calling a service without corresponding api key\n', ->
    sl = new SL {realtimeInformation: "xxx"}
    expect( -> sl.trafficSituation() ).to.throw /You have not supplied an API key for the (.*) service/
    expect( -> sl.locationLookup {} ).to.throw /You have not supplied an API key for the (.*) service/

  describe '.realtimeInformation', ->

    beforeEach (done) ->
      response = JSON.stringify require('./fixtures/success/realtimeInformation')
      sinon
        .stub(request, 'get')
        .yields(null, null, response)
      done()

    afterEach (done) ->
      request.get.restore()
      done()

    it 'should make request to realtimeinformation endpoint', (done) ->
      sl = new SL {realtimeInformation: "xxx"}
      sl.realtimeInformation (err, data) ->
        url = request.get.args[0][0].url
        expect(url).to.eql 'http://api.sl.se/api2/realtimedepartures.json?key=xxx'
        done()

    it 'should return response body as second argument in callback', (done) ->
      sl = new SL {realtimeInformation: "xxx"}
      sl.realtimeInformation (err, data) ->
        expect(err).to.be.null
        expect(data).to.not.be.empty
        expect(data).to.be.an "object"
        done()

    it 'should call the callback only once', (done) ->
      sl = new SL {realtimeInformation: "xxx"}
      sl.realtimeInformation (err, data) ->
        expect(request.get.calledOnce).to.eql true
        done()

    it 'options object should modify query string for request', (done) ->
      sl = new SL {realtimeInformation: "xxx"}
      sl.realtimeInformation {siteid: 9507}, (err, data) ->
        url = request.get.args[0][0].url
        expect(url).to.eql 'http://api.sl.se/api2/realtimedepartures.json?siteid=9507&key=xxx'
        done()

    it 'should return JSON if format is supplied at instantiation', (done) ->
      sl = new SL {realtimeInformation: "xxx"}, 'json'
      sl.realtimeInformation {}, (err, data) ->
        expect( isJSON(data) ).to.eql true
        done()

  describe 'error', ->

    after (done) ->
      request.get.restore()
      done()

    it 'should throw error if response has StatusCode other than 0', (done) ->

      response = JSON.stringify require('./fixtures/error/realtimeInformation_4001')
      sinon
        .stub(request, 'get')
        .yields(null, null, response)

      sl = new SL {realtimeInformation: "xxx"}
      sl.realtimeInformation (err, data) ->
        expect(err).not.to.be.null
        done()

    it 'should throw error if response contains errorCode', (done) ->
      done()

  # describe '#locationLookup', ->

  # describe '#trafficSituation', ->

  # describe '#disturbanceInformation', ->
  #   describe '#deviations', ->
  #   describe '#deviationsRawData', ->

  # describe '#tripPlanner', ->
  #   describe '#trip', ->
  #   describe '#journeyDetail', ->
  #   describe '#geometry', ->



