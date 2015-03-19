
_       = require 'lodash'
request = require 'request'
deepPluck = require 'deep-pluck'

isError = (errorCode) ->
  if errorCode? and errorCode.toString() isnt '0' then true else false

createErrorMsg = (body, codeKey, msgKey) ->
  [code, msg] = [deepPluck(body, codeKey)[0], deepPluck(body, msgKey)[0]]
  if isError(code) then "#{code} - #{msg}" else null

parseResponse = (body) ->
  body = JSON.parse body
  if body.StatusCode?
    [err, data] = [createErrorMsg(body, 'StatusCode', 'Message'), body.ResponseData]
  else
    [err, data] = [createErrorMsg(body, 'errorCode', 'errorText'), body]
  [err, data]

module.exports = (url, raw, deferred) ->
  request.get { url }, (err, response, body) ->
    unless err or raw
      [err, body] = parseResponse body
    if err then deferred.reject err
    else deferred.resolve body
