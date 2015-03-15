
Base = require './base'

class TrafficSituation extends Base
  constructor: (config) ->
    @key = config.keys.trafficSituation
    @service = 'trafficSituation (SL Trafikläget 2)'
    super

module.exports = (args...) ->
  service = new TrafficSituation args...
  (args...) -> service.prepareRequest 'trafficsituation', args...
