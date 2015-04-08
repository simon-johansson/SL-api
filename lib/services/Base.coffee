
qs      = require 'querystring'
_       = require 'lodash'
Q       = require 'q'

request = require '../request'
errors  = require '../errors'
{ api } = require '../config'

checkArgumentOrder = (args...) ->
  if not args[0]? then [{}, undefined]
  else if _(args[0]).isFunction() then [{}, args[0]]
  else args

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

  prepareRequest: (action, args...) ->
    if not @key then throw new errors.NoKeySuppliedForServiceError @service
    deferred = Q.defer()
    [options, clb] = checkArgumentOrder args...
    options = @__mergeDefaultOptions options
    url = @__createUrl options, action
    request url, @getRaw, deferred
    deferred.promise.nodeify clb

module.exports = Base
