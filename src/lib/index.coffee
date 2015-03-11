
_ = require 'lodash'

RealtimeInformation = require './realtime'
LocationLookup      = require './location'
TripPlanner         = require './trip'

correctKeysSupplied = (keys) ->
  possibleKeys = ['realtimeInformation', 'locationLookup', 'tripPlanner']
  _.intersection(_.keysIn(keys), possibleKeys).length > 0

class SL
  constructor: (@keys) ->
    unless keys? or correctKeysSupplied keys
      throw new Error 'At least one API key is required'
    @createServices keys

  createServices: (keys) ->
    @realtimeInformation = new RealtimeInformation keys.realtimeInformation
    @locationLookup = new LocationLookup keys.locationLookup
    @tripPlanner = new TripPlanner keys.tripPlanner

module.exports = SL

