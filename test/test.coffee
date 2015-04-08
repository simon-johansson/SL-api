# coffeelint: disable=max_line_length

fs         = require 'fs'
sinon      = require 'sinon'
isJSON     = require 'is-json'
request    = require 'request'

SL = require '../lib/'

chai       = require 'chai'
{ expect } = require 'chai'
chai.use(require('chai-xml'))

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
    expect( -> new SL keys, 'XmL' ).to.not.throw Error
    expect( -> new SL keys, 'json' ).to.not.throw Error
    expect( -> new SL keys, 'JsON' ).to.not.throw Error

  it "should throw error if no key is supplied", ->
    expect( -> new SL() ).to.throw /One of the following API keys have to be supplied/

  it "should throw error if supplied keys is not an object", ->
    expect( -> new SL("string") ).to.throw /The supplied API key\(s\) has to be an object/
    expect( -> new SL(123) ).to.throw /The supplied API key\(s\) has to be an object/

  it "should throw error if invalid keyname is supplied", ->
    invalidKeyNameSupplied = -> new SL({realtimeInformation: "xxx", wrongKeyName: "xxx"})
    expect( invalidKeyNameSupplied ).to.throw /The supplied key (.*) should be one of the following/

  it "should throw error if invalid response format is supplied\n", ->
    expect( -> new SL({realtimeInformation: "xxx"}, "txt") ).to.throw /(.*) which you supplied is not supported./
    expect( -> new SL({realtimeInformation: "xxx"}, 123) ).to.throw /(.*) which you supplied is not supported./
    expect( -> new SL({realtimeInformation: "xxx"}, {}) ).to.throw /(.*) which you supplied is not supported./
    expect( -> new SL({realtimeInformation: "xxx"}, []) ).to.throw /(.*) which you supplied is not supported./

  describe 'SL', ->

    beforeEach (done) ->
      sinon.stub(request, 'get').yields(null, null, JSON.stringify({}))
      done()

    afterEach (done) ->
      request.get.restore()
      done()

    describe '#realtimeInformation', ->
      it 'should make request to realtimedepartures endpoint', (done) ->
        new SL(keys).realtimeInformation (err, data) ->
          url = request.get.args[0][0].url
          expect(url).to.eql 'http://api.sl.se/api2/realtimedepartures.json?key=xxx'
          done()

    describe '#locationLookup', ->
      it 'should make request to typeahead endpoint', (done) ->
        new SL(keys).locationLookup (err, data) ->
          url = request.get.args[0][0].url
          expect(url).to.eql 'http://api.sl.se/api2/typeahead.json?key=xxx'
          done()

    describe '#trafficSituation', ->
      it 'should make request to trafficsituation endpoint', (done) ->
        new SL(keys).trafficSituation (err, data) ->
          url = request.get.args[0][0].url
          expect(url).to.eql 'http://api.sl.se/api2/trafficsituation.json?key=xxx'
          done()

    describe '#disturbanceInformation', ->

      describe '#deviations', ->
        it 'should make request to deviations endpoint', (done) ->
          new SL(keys).disturbanceInformation.deviations (err, data) ->
            url = request.get.args[0][0].url
            expect(url).to.eql 'http://api.sl.se/api2/deviations.json?key=xxx'
            done()

      describe '#deviationsRawData', ->
        it 'should make request to deviationsrawdata endpoint', (done) ->
          new SL(keys).disturbanceInformation.deviationsrawdata (err, data) ->
            url = request.get.args[0][0].url
            expect(url).to.eql 'http://api.sl.se/api2/deviationsrawdata.json?key=xxx'
            done()

    describe '#tripPlanner', ->

      describe '#trip', ->
        it 'should make request to TravelplannerV2/trip endpoint', (done) ->
          new SL(keys).tripPlanner.trip (err, data) ->
            url = request.get.args[0][0].url
            expect(url).to.eql 'http://api.sl.se/api2/TravelplannerV2/trip.json?key=xxx'
            done()

      describe '#journeyDetail', ->
        it 'should make request to TravelplannerV2/journeydetail endpoint', (done) ->
          new SL(keys).tripPlanner.journeyDetail (err, data) ->
            url = request.get.args[0][0].url
            expect(url).to.eql 'http://api.sl.se/api2/TravelplannerV2/journeydetail.json?key=xxx'
            done()

      describe '#geometry', ->
        it 'should make request to TravelplannerV2/geometry endpoint\n', (done) ->
          new SL(keys).tripPlanner.geometry (err, data) ->
            url = request.get.args[0][0].url
            expect(url).to.eql 'http://api.sl.se/api2/TravelplannerV2/geometry.json?key=xxx'
            done()


  describe 'common', ->

    sl = new SL {realtimeInformation: "xxx", locationLookup: "xxx"}

    beforeEach (done) ->
      response1 = JSON.stringify require('./fixtures/success/locationLookup')
      response2 = JSON.stringify require('./fixtures/success/realtimeInformation')
      callback = sinon.stub request, 'get'
      callback.onCall(0).yields null, null, response1
      callback.onCall(1).yields null, null, response2
      done()

    afterEach (done) ->
      request.get.restore()
      done()

    describe 'callback', ->

      it 'should be able to pass a callback as the first argument', ->
        expect( -> sl.realtimeInformation (err, data) -> ).to.not.throw Error

      it 'should return response body as second argument in callback', (done) ->
        sl.realtimeInformation (err, data) ->
          expect(err).to.be.null
          expect(data).to.not.be.empty
          expect(data).to.be.an "array"
          done()

      it 'should only make one call to the api', (done) ->
        sl.realtimeInformation (err, data) ->
          expect(request.get.calledOnce).to.eql true
          done()

      it 'should be able to pass options object as first argument', ->
        expect( -> sl.realtimeInformation {}, (err, data) -> ).to.not.throw Error

      it 'options object should modify query string for the request', (done) ->
        sl.realtimeInformation {siteid: 9507}, (err, data) ->
          url = request.get.args[0][0].url
          expect(url).to.contain 'siteid=9507&key=xxx'
          done()

    describe 'promise', ->

      it 'methods should return a promise', ->
        promise = sl.realtimeInformation()
        expect(promise).to.have.property "then"
        expect(promise).to.have.property "fail"
        expect(promise).to.have.property "done"

      it 'promise should contain response body when resolved', (done) ->
        promise = sl.realtimeInformation()
        promise.then (data) ->
          expect(data).to.not.be.empty
          expect(data).to.be.an "array"
        .done ->
          done()

      it 'query string should contain api key even if options object is not supplied', (done) ->
        promise = sl.realtimeInformation()
        promise.then (data) ->
          url = request.get.args[0][0].url
          expect(url).to.contain 'key=xxx'
        .done ->
          done()

      it 'options object should modify query string for the request', (done) ->
        promise = sl.realtimeInformation {siteid: 9507}
        promise.then (data) ->
          url = request.get.args[0][0].url
          expect(url).to.contain 'siteid=9507&key=xxx'
        .done ->
          done()

      it 'should be able to chain promises\n', (done) ->

        sl.locationLookup({searchstring: "tegnergatan"})
          .then (data) ->
            sl.realtimeInformation {siteid: data[0].SiteId}
          .then (data) ->
            expect(data.Buses).to.be.an "array"
          .done ->
            done()


  describe 'errors', ->

    it 'should throw error if calling a service without corresponding api key', ->
      sl = new SL {realtimeInformation: "xxx"}
      expect( -> sl.trafficSituation() ).to.throw /You have not supplied an API key for the (.*) service/
      expect( -> sl.disturbanceInformation.deviations() ).to.throw /You have not supplied an API key for the (.*) service/

    describe 'callback', ->

      sl = new SL keys

      afterEach (done) ->
        request.get.restore()
        done()

      it 'should throw error if response has StatusCode other than 0', (done) ->
        response = JSON.stringify require('./fixtures/error/realtimeInformation')
        sinon.stub(request, 'get').yields(null, null, response)

        sl.realtimeInformation {}, (err, data) ->
          expect(err).not.to.be.null
          done()

      it 'should throw error if response contains errorCode', (done) ->
        response = JSON.stringify require('./fixtures/error/tripplanner')
        sinon.stub(request, 'get').yields(null, null, response)

        sl.tripPlanner.trip {}, (err, data) ->
          expect(err).not.to.be.null
          done()

    describe 'promise', ->

      sl = new SL keys

      afterEach (done) ->
        request.get.restore()
        done()

      it 'should throw error if response has StatusCode other than 0', (done) ->
        response = JSON.stringify require('./fixtures/error/realtimeInformation')
        sinon.stub(request, 'get').yields(null, null, response)

        sl.realtimeInformation {}
        .fail (err) ->
          expect(err).not.to.be.null
        .done ->
          done()

      it 'should throw error if response contains errorCode\n', (done) ->
        response = JSON.stringify require('./fixtures/error/tripplanner')
        sinon.stub(request, 'get').yields(null, null, response)

        sl.tripPlanner.trip {}
        .fail (err) ->
          expect(err).not.to.be.null
        .done ->
          done()


  describe 'raw formats', ->

    afterEach (done) ->
      request.get.restore()
      done()

    it 'should return JSON if "json" format is supplied at instantiation', (done) ->
      response = JSON.stringify require('./fixtures/success/realtimeInformation')
      sinon.stub(request, 'get').yields(null, null, response)

      sl = new SL {realtimeInformation: "xxx"}, 'json'

      sl.realtimeInformation {}, (err, data) ->
        url = request.get.args[0][0].url
        expect(url).to.contain "json"
        expect( isJSON(data) ).to.eql true
        done()

    it 'should return XML if "xml" format is supplied at instantiation', (done) ->
      response = fs.readFileSync "#{__dirname}/fixtures/success/trafficSituation.xml", 'utf8'
      sinon.stub(request, 'get').yields(null, null, response)

      sl = new SL {trafficSituation: "xxx"}, 'xml'

      sl.trafficSituation (err, data) ->
        url = request.get.args[0][0].url
        expect(url).to.contain "xml"
        expect(data).xml.to.be.valid()
        done()



