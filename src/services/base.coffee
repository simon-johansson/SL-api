
_       = require 'lodash'

request = require '../request'
errors = require '../errors'

api =
  protocol: 'http'
  subdomain: 'api'
  domain: 'sl.se'
  basepath: 'api2'
  format: 'json'

checkArgumentOrder = (options, fn) ->
  if _.isFunction options then [options, {}]
  else [fn, options]

class Base
  constructor: (config) ->
    @getRaw = config.getRaw

  # WIP
  setDefaults: (@defaults) ->

  __createUrl: (options = {}, format = api.format, action) ->
    baseURL = "#{api.protocol}://#{api.subdomain}.#{api.domain}/#{api.basepath}/"
    "#{baseURL}#{action}.#{format}?#{qs.stringify options}"

  __mergeDefaultOptions: (options, self) ->
    _.defaults options, self.defaults, { @key }

  prepareRequest: (action, options, fn) ->
    if not @key
      throw new errors.NoKeySuppliedForServiceError @service
    [fn, options] = checkArgumentOrder options, fn
    options = __mergeDefaultOptions options
    url = __createUrl options, @getRaw, action
    request.fetch url, @getRaw, fn

module.exports = Base
