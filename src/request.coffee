
_       = require 'lodash'
request = require 'request'

findNested = (obj, predicate, memo = []) ->
  for key, val of obj
    if predicate of obj
      memo.push obj[predicate]
      break
    else
      findNested(val, predicate, memo) if _(val).isObject
  if memo.length then _.first(_.flatten(memo)) else null

isError = (errorCode) ->
  if errorCode? and errorCode.toString().length > 1 then true else false

createErrorMsg = (body, codeKey, errorKey) ->
  [code, msg] = [findNested(body, codeKey), findNested(body, errorKey)]
  if isError(code, msg) then "#{code} - #{msg}" else null

parseResponse = (body) ->
  body = JSON.parse body
  if body.StatusCode?
    [err, data] = [createErrorMsg(body, 'StatusCode', 'Message'), body.ResponseData]
  else
    [err, data] = [createErrorMsg(body, 'errorCode', 'errorText'), body]
  [err, data]

module.exports =

  fetch: (url, raw, deferred) ->
    request { url }, (err, response, body) ->
      unless err or raw
        [err, body] = parseResponse body
      if err then deferred.reject err
      else deferred.resolve body
