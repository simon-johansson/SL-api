
qs      = require 'querystring'
_       = require 'lodash'
request = require 'request'

baseUrl = "http://api.sl.se/api2/"

module.exports =

  createUrl: (options = {}, action) ->
    "#{baseUrl}#{action}.json?#{qs.stringify options}"

  # Send requests
  fetch: (url, fn = ->) ->
    options = { url, json: true }
    request options, (err, response, body) ->
      return fn.call body, err, body if err?
      if _.intersection(_.keysIn(body), ['TripList', 'JourneyDetail', 'Geometry']).length > 0
        method = _.keys(body)[0]
        err = "#{body[method].errorCode} #{body[method].errorText}" if body[method].errorCode?
        fn.call body, err, body
      else
        err = "#{body.StatusCode} #{body.Message}" if body.StatusCode isnt 0
        fn.call body, err, body.ResponseData

