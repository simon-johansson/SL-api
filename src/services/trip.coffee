
Base = require './base'

class TripPlanner extends Base
  constructor: (@key, @getRaw) ->
    @service = 'tripPlanner (SL Reseplanerare 2)'

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
