
NoKeySuppliedError = ->
  self = new Error "You have to supply as least one API key"
  self.name = 'NoKeySuppliedError'
  self.__proto__ = NoKeySuppliedError::
  self
NoKeySuppliedError::__proto__ = Error::

WrongKeyNamesSuppliedError = ->
  self = new Error "Check the names of the keys you have supplied"
  self.name = 'WrongKeyNamesSuppliedError'
  self.__proto__ = WrongKeyNamesSuppliedError::
  self
WrongKeyNamesSuppliedError::__proto__ = Error::

NoKeySuppliedForServiceError = (service) ->
  self = new Error "You have not supplied an API key for the #{service} service"
  self.name = 'NoKeySuppliedForServiceError'
  self.__proto__ = NoKeySuppliedForServiceError::
  self
NoKeySuppliedForServiceError::__proto__ = Error::

module.exports = {
  NoKeySuppliedError: NoKeySuppliedError
  WrongKeyNamesSuppliedError: WrongKeyNamesSuppliedError
  NoKeySuppliedForServiceError: NoKeySuppliedForServiceError
}
