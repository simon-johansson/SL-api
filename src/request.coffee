
qs      = require 'querystring'
_       = require 'lodash'
request = require 'request'

findNested = (obj, key, memo = []) ->
  for k, val of obj
    if _.has obj, key
      memo.push obj[key]
      break
    else
      findNested val, key, memo if _.isObject val
  if memo.length then _.first _.flatten memo else null

isError = (errorCode) ->
  if errorCode? and errorCode.toString().length > 1 then true else false

createErrorMsg = (body, codeKey, errorKey) ->
  [code, msg] = [findNested(body, codeKey), findNested(body, errorKey)]
  # console.log code, msg
  if isError code, msg then "#{code} - #{msg}" else null

parseResponse = (body) ->
  body = JSON.parse body
  if body['StatusCode']?
    # console.log 'creating StatusCode'
    [err, data] = [createErrorMsg(body, 'StatusCode', 'Message'), body['ResponseData']]
  else
    # console.log 'creating errorCode'
    [err, data] = [createErrorMsg(body, 'errorCode', 'errorText'), body]
  [err, data]

module.exports =

  fetch: (url, getRaw, fn) ->
    request { url, qs: options }, (err, response, body) ->
      unless err?
        [err, data] = if getRaw then [null, body] else parseResponse body
      fn.call body, err, data if fn?
