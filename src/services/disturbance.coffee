
Base = require './base'

class DisturbanceInformation extends Base
  constructor: (@key, @getRaw) ->
    @service = 'disturbanceInformation (SL Störningsinformation 2)'

module.exports = (args...) ->
  service = new DisturbanceInformation args...
  {
    deviations: (args...) ->
      service.prepareRequest 'deviations', args...
    deviationsRawData: (args...) ->
      service.prepareRequest 'deviationsrawdata', args...
  }
