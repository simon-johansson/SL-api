
qs      = require 'querystring'
_       = require 'lodash'
Q       = require 'q'
request   = require 'request'

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

  createUrl: (options, action) ->
    "#{@baseURL}#{action}.#{@format}?#{qs.stringify options}"

  mergeDefaultOptions: (options) ->
    _.defaults options, @defaults, { @key }

  parseResponse: (body) ->
    body = JSON.parse body
    err = if body.StatusCode isnt 0
      "#{body.StatusCode} - #{body.Message}"
    else null
    [err, body.ResponseData]

  fetchData: (url, clb) ->
    request.get { url }, (err, response, body) =>
      unless err or @getRaw
        [err, body] = @parseResponse body
      clb err, body

  prepareRequest: (action, args...) ->
    if not @key then throw new errors.NoKeySuppliedForServiceError @service
    deferred = Q.defer()
    [options, clb] = checkArgumentOrder args...
    options = @mergeDefaultOptions options
    url = @createUrl options, action
    @fetchData url, (err, body) ->
      if err then deferred.reject err
      else deferred.resolve body
    deferred.promise.nodeify clb

module.exports = Base
