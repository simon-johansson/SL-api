
_       = require 'lodash'
request = require './request'

class SL
  constructor: (config) ->
    unless config.key then throw new Error('API key required')
    @format = config.format or 'json'

  realtimeInformation: (options, fn) ->
    if _.isFunction(options)
      [fn, options] = [options, null]

    url = request.realtimeUrl @format, options

    request.get url, fn

  locationLookup: (options, fn) ->
    if _.isFunction(options)
      [fn, options] = [options, null]

    url = request.locationUrl @format, options

    request.get url, fn

module.exports = SL
