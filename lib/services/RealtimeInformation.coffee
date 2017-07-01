
Base = require './Base'

class RealtimeInformation extends Base
  constructor: (config) ->
    @key = config.keys.realtimeInformation
    @service = 'realtimeInformation (SL Realtidsinformation 4)'
    super

module.exports = (args...) ->
  service = new RealtimeInformation args...
  (args...) -> service.prepareRequest "realtimedeparturesV4", args...
