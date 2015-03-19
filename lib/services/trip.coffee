
Base = require './base'

class TripPlanner extends Base
  constructor: (config) ->
    @key = config.keys.tripPlanner
    @service = 'tripPlanner (SL Reseplanerare 2)'
    super

module.exports = (args...) ->
  service = new TripPlanner args...
  {
    trip: (args...) ->
      service.prepareRequest 'TravelplannerV2/trip', args...
    journeyDetail: (args...) ->
      service.prepareRequest 'TravelplannerV2/journeydetail', args...
    geometry: (args...) ->
      service.prepareRequest 'TravelplannerV2/geometry', args...
  }
