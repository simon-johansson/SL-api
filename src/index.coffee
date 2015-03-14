
_ = require 'lodash'
typeOf = require 'type-of'

errors = require './errors'

RealtimeInformation    = require './services/realtime'
LocationLookup         = require './services/location'
TripPlanner            = require './services/trip'
TrafficSituation       = require './services/traffic'
DisturbanceInformation = require './services/disturbance'

checkIfKeyIsSupplied = (keys) ->
  throw new errors.NoKeySuppliedError unless keys?

checkIfKeyIsObject = (keys) ->
  type = typeOf keys
  unless type is 'object' then throw new error.wrongKeyFormatSupplied type

checkKeyNames = (keys) ->
  # Bryt ut till egen fil
  possibleKeys = [
    'realtimeInformation'
    'locationLookup'
    'tripPlanner'
    'trafficSituation'
    'disturbanceInformation'
  ]
  for key, val of keys
    if key not in possibleKeys
      throw new errors.WrongKeyNameSuppliedError key

checkResponseFormat = (format) ->
  if format and format.toLowerCase() not in ['json', 'xml']
    throw new errors.WrongFormatSuppliedError format

class SL
  constructor: (@keys, @format) ->
    checkIfKeyIsSupplied @keys
    checkIfKeyIsObject @keys
    checkKeyNames @keys
    checkResponseFormat @format
    @createServices()

  createServices: ->
    @realtimeInformation = new RealtimeInformation @
    @locationLookup = new LocationLookup @keys.locationLookup, @getRaw
    @tripPlanner = new TripPlanner @keys.tripPlanner, @getRaw
    @trafficSituation = new TrafficSituation @keys.trafficSituation, @getRaw
    @disturbanceInformation = new DisturbanceInformation @keys.disturbanceInformation, @getRaw

module.exports = SL

