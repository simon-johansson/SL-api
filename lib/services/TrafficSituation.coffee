
Base = require './Base'

class TrafficSituation extends Base
  constructor: (config) ->
    @key = config.keys.trafficSituation
    @service = 'trafficSituation (SL Trafikläget 2)'
    super

  parseResponse: (body) ->
    body = JSON.parse body
    err = if body.StatusCode isnt 0
      "#{body.StatusCode} - #{body.Message}"
    else null
    [err, body.ResponseData.TrafficTypes]

module.exports = (args...) ->
  service = new TrafficSituation args...
  (args...) -> service.prepareRequest 'trafficsituation', args...
