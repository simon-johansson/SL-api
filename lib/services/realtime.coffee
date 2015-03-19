
Base = require './base'

class RealtimeInformation extends Base
  constructor: (config) ->
    @key = config.keys.realtimeInformation
    @service = 'realtimeInformation (SL Realtidsinformation 3)'
    super

module.exports = (args...) ->
  service = new RealtimeInformation args...
  (args...) -> service.prepareRequest "realtimedepartures", args...
