
Base = require './base'

class RealtimeInformation extends Base
  constructor: (@key) ->

  get: (args...) ->
    @prepareRequest.call @, args..., 'realtimedepartures'

module.exports = RealtimeInformation
