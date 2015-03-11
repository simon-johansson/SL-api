
Base = require './base'

class TripPlanner extends Base
  constructor: (@key) ->

  trip: (args...) ->
    @prepareRequest.call @, args..., "TravelplannerV2/trip"

  journeyDetail: (args...) ->
    @prepareRequest.call @, args..., "TravelplannerV2/journeydetail"

  geometry: (args...) ->
    @prepareRequest.call @, args..., "TravelplannerV2/geometry"

module.exports = TripPlanner
