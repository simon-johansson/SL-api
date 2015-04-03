
Base = require './base'

class DisturbanceInformation extends Base
  constructor: (config) ->
    @key = config.keys.disturbanceInformation
    @service = 'disturbanceInformation (SL Störningsinformation 2)'
    super


module.exports = (args...) ->
  service = new DisturbanceInformation args...
  {
    deviations: (args...) ->
      service.prepareRequest 'deviations', args...
    deviationsrawdata: (args...) ->
      service.prepareRequest 'deviationsrawdata', args...
  }
