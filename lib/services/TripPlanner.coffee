
Base = require './Base'

class TripPlanner extends Base
  constructor: (config) ->
    @key = config.keys.tripPlanner
    @service = 'tripPlanner (SL Reseplanerare 2)'
    super

  parseResponse: (body) ->
    body = JSON.parse body
    if body.TripList?
      service = 'TripList'
      data = body.TripList.Trip
    else if body.JourneyDetail?
      service = 'JourneyDetail'
      data = body.JourneyDetail
    else if body.Geometry?
      service = 'Geometry'
      data = body.Geometry.Points.Point
    err = if service and body[service].errorCode?
      "#{body[service].errorCode} - #{body[service].errorText}"
    else null
    [err, data]

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
