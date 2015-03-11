
_       = require 'lodash'
request = require './request'

checkArgumentOrder = (options, fn) ->
  if _.isFunction options then [options, {}]
  else [fn, options]

class Base

  setDefaults: (@defaults) ->

  prepareRequest: (options, fn, action) ->
    throw new Error('API key required') unless @key?
    [fn, options] = checkArgumentOrder options, fn
    _.defaults options, @defaults, { @key }
    url = request.createUrl options, action
    request.fetch url, fn

module.exports = Base
