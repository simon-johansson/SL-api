
Base = require './base'

class TrafficSituation extends Base
  constructor: (@key, @getRaw) ->
    @service = 'trafficSituation (SL Trafikläget 2)'

module.exports = (args...) ->
  service = new TrafficSituation args...
  (args...) -> service.prepareRequest 'trafficsituation', args...
