
NoKeySuppliedError = ->
  self = new Error "You have to supply as least one API key."
  self.name = 'NoKeySuppliedError'
  self.__proto__ = NoKeySuppliedError::
  self
NoKeySuppliedError::__proto__ = Error::

WrongKeyNameSuppliedError = (key) ->
  # Skriv ut vilka nycklar som finns
  self = new Error "#{key} should be one of the following ..."
  self.name = 'WrongKeyNameSuppliedError'
  self.__proto__ = WrongKeyNameSuppliedError::
  self
WrongKeyNameSuppliedError::__proto__ = Error::

NoKeySuppliedForServiceError = (service) ->
  self = new Error "You have not supplied an API key for the #{service} service."
  self.name = 'NoKeySuppliedForServiceError'
  self.__proto__ = NoKeySuppliedForServiceError::
  self
NoKeySuppliedForServiceError::__proto__ = Error::

WrongFormatSuppliedError = (format) ->
  self = new Error "#{format} which you supplied is not supported. \
                    Use either JSON, XML or omit format completely \
                    to get the response as a JavaScript object."
  self.name = 'WrongFormatSuppliedError'
  self.__proto__ = WrongFormatSuppliedError::
  self
WrongFormatSuppliedError::__proto__ = Error::

module.exports =
  NoKeySuppliedError: NoKeySuppliedError
  WrongKeyNameSuppliedError: WrongKeyNameSuppliedError
  NoKeySuppliedForServiceError: NoKeySuppliedForServiceError
  WrongFormatSuppliedError: WrongFormatSuppliedError
