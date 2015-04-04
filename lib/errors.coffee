
{ availableKeys, availableFormats } = require './config'

exported = {}

errors = [
  {
    error: 'NoKeySuppliedError'
    msg: ->
          "One of the following API keys have to be supplied \
           upon instantiation: #{availableKeys.join(', ')}."
  }, {
    error: 'InvalidKeyNameSuppliedError'
    msg: (key) ->
          "The supplied key '#{key}' should be one of \
          the following #{availableKeys.join(', ')}"
  }, {
    error: 'NoKeySuppliedForServiceError'
    msg: (service) ->
          "You have not supplied an API key for the #{service} \
          service which you attempted to use."
  }, {
    error: 'InvalidKeyFormatSupplied'
    msg: ->
          "The supplied API key(s) has to be an object following the format: \
          { realtimeInformation: <API key from trafiklab.se> }"
  }, {
    error: 'InvalidResponseFormatSuppliedError'
    msg: (format) ->
          "'#{format}' which you supplied is not supported. \
          Use either #{availableFormats.join(', ')} or omit \
          format completely to get the response as a JavaScript object."
  }
]

alias = (obj, error) ->
  obj[error.error] = (arg) ->
    self = new Error error.msg(arg)
    self.name = error.error
    self.__proto__ = obj[error.error]::
    self
  obj[error.error]::__proto__ = Error::

alias exported, error for error in errors

module.exports = exported
