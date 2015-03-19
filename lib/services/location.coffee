
Base = require './base'

class LocationLookup extends Base
  constructor: (config) ->
    @key = config.keys.locationLookup
    @service = 'locationLookup (SL Platsuppslag)'
    super

module.exports = (args...) ->
  service = new LocationLookup args...
  (args...) -> service.prepareRequest 'typeahead', args...
