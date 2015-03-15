
_ = require 'lodash'
typeOf = require 'type-of'

errors = require './errors'
{ availableKeys, availableFormats } = require './api_config'

RealtimeInformation    = require './services/realtime'
LocationLookup         = require './services/location'
TripPlanner            = require './services/trip'
TrafficSituation       = require './services/traffic'
DisturbanceInformation = require './services/disturbance'

checkIfKeyIsSupplied = (keys) ->
  throw new errors.NoKeySuppliedError unless keys?

checkIfKeyIsObject = (keys) ->
  type = typeOf keys
  unless type is 'object' then throw new error.InvalidKeyFormatSupplied type

checkKeyNames = (keys) ->
  for key, val of keys
    if key not in availableKeys
      throw new errors.InvalidKeyNameSuppliedError key

checkSuppliedFormat = (format) ->
  if format and format.toUpperCase() not in availableFormats
    throw new errors.InvalidResponseFormatSuppliedError format

class SL
  constructor: (@keys, @format) ->
    checkIfKeyIsSupplied @keys
    checkIfKeyIsObject @keys
    checkKeyNames @keys
    checkSuppliedFormat @format
    @createServices()

  createServices: ->
    @realtimeInformation = new RealtimeInformation @
    @locationLookup = new LocationLookup @
    @disturbanceInformation = new DisturbanceInformation @
    @trafficSituation = new TrafficSituation @
    @tripPlanner = new TripPlanner @

module.exports = SL

