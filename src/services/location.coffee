
Base = require './base'

class LocationLookup extends Base
  constructor: (@key, @getRaw) ->
    @service = 'locationLookup (SL Platsuppslag)'

module.exports = (args...) ->
  service = new LocationLookup args...
  (args...) -> service.prepareRequest 'typeahead', args...
