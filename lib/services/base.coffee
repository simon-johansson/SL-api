
qs      = require 'querystring'
_       = require 'lodash'
Q       = require 'q'

request = require '../request'
errors  = require '../errors'
{ api } = require '../config'

checkArgumentOrder = (options, fn) ->
  if _(options).isFunction() then [options, {}]
  else [fn, options]

class Base
  constructor: (config) ->
    @format = config.format or 'json'
    @getRaw = !!config.format
    @baseURL = "#{api.protocol}://#{api.subdomain}.#{api.domain}/#{api.basepath}/"

  # WIP
  setDefaults: (@defaults) ->

  __createUrl: (options, action) ->
    "#{@baseURL}#{action}.#{@format}?#{qs.stringify options}"

  __mergeDefaultOptions: (options) ->
    _.defaults options, @defaults, { @key }

  prepareRequest: (action, options, fn) ->
    if not @key then throw new errors.NoKeySuppliedForServiceError @service
    deferred = Q.defer()
    [fn, options] = checkArgumentOrder options, fn
    options = @__mergeDefaultOptions options
    url = @__createUrl options, action
    request url, @getRaw, deferred
    deferred.promise.nodeify fn

module.exports = Base
