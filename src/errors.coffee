
{ availableKeys, availableFormats } = require './api_config'

NoKeySuppliedError = ->
  self = new Error "You have to supply as least one API key."
  self.name = 'NoKeySuppliedError'
  self.__proto__ = NoKeySuppliedError::
  self
NoKeySuppliedError::__proto__ = Error::

InvalidKeyNameSuppliedError = (key) ->
  self = new Error "The supplied key '#{key}' should be one of \
                    the following #{availableKeys.join(', ')}"
  self.name = 'InvalidKeyNameSuppliedError'
  self.__proto__ = InvalidKeyNameSuppliedError::
  self
InvalidKeyNameSuppliedError::__proto__ = Error::

NoKeySuppliedForServiceError = (service) ->
  self = new Error "You have not supplied an API key for the #{service} service."
  self.name = 'NoKeySuppliedForServiceError'
  self.__proto__ = NoKeySuppliedForServiceError::
  self
NoKeySuppliedForServiceError::__proto__ = Error::

InvalidKeyFormatSupplied = (service) ->
  self = new Error "..."
  self.name = 'InvalidKeyFormatSupplied'
  self.__proto__ = InvalidKeyFormatSupplied::
  self
InvalidKeyFormatSupplied::__proto__ = Error::

InvalidResponseFormatSuppliedError = (format) ->
  self = new Error "#{format} which you supplied is not supported. \
                    Use either #{availableFormats.join(', ')} or omit \
                    format completely to get the response as a JavaScript object."
  self.name = 'InvalidResponseFormatSuppliedError'
  self.__proto__ = InvalidResponseFormatSuppliedError::
  self
InvalidResponseFormatSuppliedError::__proto__ = Error::

module.exports =
  NoKeySuppliedError: NoKeySuppliedError
  InvalidKeyNameSuppliedError: InvalidKeyNameSuppliedError
  NoKeySuppliedForServiceError: NoKeySuppliedForServiceError
  InvalidResponseFormatSuppliedError: InvalidResponseFormatSuppliedError
  InvalidKeyFormatSupplied: InvalidKeyFormatSupplied
