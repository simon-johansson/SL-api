
{ expect } = require 'chai'
sinon      = require 'sinon'
request    = require 'request'

SL = require '../lib/'

keys =
  realtimeInformation: 'xxx'
  locationLookup: 'xxx'
  tripPlanner: 'xxx'
  trafficSituation: 'xxx'
  disturbanceInformation: 'xxx'

describe 'SL (Storstockholms Lokaltrafik) API Wrapper', ()->

  describe 'new SL()', ()->
    it "should throw NoKeySuppliedError", ->
      noKeySupplied = -> new SL()
      expect( noKeySupplied ).to.throw /One of the following API keys have to be supplied/

  describe 'new SL("string")', ()->
    it "should throw InvalidKeyFormatSuppliedError", ->
      invalidKeyFormatSupplied = -> new SL("string")
      expect( invalidKeyFormatSupplied ).to.throw /The supplied API key\(s\) has to be an object/

  describe 'new SL({realtimeInformation: "xxx", wrongKeyName: "xxx"})', ()->
    it "should throw InvalidKeyNameSuppliedError", ->
      invalidKeyNameSupplied = -> new SL({realtimeInformation: "xxx", wrongKeyName: "xxx"})
      expect( invalidKeyNameSupplied ).to.throw /The supplied key (.*) should be one of the following/

  describe 'new SL({realtimeInformation: "xxx"}, "txt")', ->
    it "should throw InvalidResponseFormatSuppliedError", ->
      invalidResponseFormatSupplied = -> new SL({realtimeInformation: "xxx"}, "txt")
      expect( invalidResponseFormatSupplied ).to.throw /(.*) which you supplied is not supported./

  describe '...', ->
    it 'should throw NoKeySuppliedForServiceError', ->

  describe '#realtimeInformation', ->

    before (done) ->
      sinon
        .stub(request, 'get')
        .yields(null, null, JSON.stringify({login: "bulkan"}))
      done()

    after (done) ->
      request.get.restore()
      done()

    it 'can get user profile', (done) ->
      sl = new SL realtimeInformation: 'xxx'
      sl.realtimeInformation {siteid: 9507}, (err, data) ->
        console.log request.get.args[0]
        expect(err).to.be.null
        expect(request.get.calledOnce).to.eql true
        expect(data).to.not.be.empty
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



