
Base = require './base'

class LocationLookup extends Base
  constructor: (@key) ->

  get: (args...) ->
    @prepareRequest.call @, args..., 'typeahead'

module.exports = LocationLookup
