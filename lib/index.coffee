
_      = require 'lodash'
typeOf = require 'type-of'

err = require './errors'
{ availableKeys, availableFormats } = require './config'

RealtimeInformation    = require './services/RealtimeInformation'
LocationLookup         = require './services/LocationLookup'
TripPlanner            = require './services/TripPlanner'
TrafficSituation       = require './services/TrafficSituation'
DisturbanceInformation = require './services/DisturbanceInformation'

checkIfKeyIsSupplied = (keys) ->
  throw new err.NoKeySuppliedError unless keys?

checkIfKeyIsObject = (keys) ->
  type = typeOf keys
  unless type is 'object' then throw new err.InvalidKeyFormatSupplied type

checkKeyNames = (keys) ->
  for key, val of keys
    if key not in availableKeys
      throw new err.InvalidKeyNameSuppliedError key

checkSuppliedFormat = (format) ->
  if format
    if not _(format).isString() or format.toUpperCase() not in availableFormats
      throw new err.InvalidResponseFormatSuppliedError format

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

