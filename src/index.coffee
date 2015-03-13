
_ = require 'lodash'

errors = require './errors'

RealtimeInformation    = require './services/realtime'
LocationLookup         = require './services/location'
TripPlanner            = require './services/trip'
TrafficSituation       = require './services/traffic'
DisturbanceInformation = require './services/disturbance'

correctKeyNamesSupplied = (keys) ->
  possibleKeys = [
    'realtimeInformation'
    'locationLookup'
    'tripPlanner'
    'trafficSituation'
    'disturbanceInformation'
  ]
  _.intersection(_.keysIn(keys), possibleKeys).length > 0

class SL
  constructor: (@keys, @getRaw = false) ->
    unless @keys?
      throw new errors.NoKeySuppliedError
    unless correctKeyNamesSupplied @keys
      throw new errors.WrongKeyNamesSuppliedError
    @createServices()

  createServices: ->
    @realtimeInformation = new RealtimeInformation @
    @locationLookup = new LocationLookup @keys.locationLookup, @getRaw
    @tripPlanner = new TripPlanner @keys.tripPlanner, @getRaw
    @trafficSituation = new TrafficSituation @keys.trafficSituation, @getRaw
    @disturbanceInformation = new DisturbanceInformation @keys.disturbanceInformation, @getRaw

module.exports = SL

