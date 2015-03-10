qs      = require 'querystring'
request = require 'request'

baseUrl = "http://api.sl.se/api2/"

module.exports =

  realtimeUrl: (format, options) ->
    "#{baseUrl}realtimedepartures.#{format}?#{qs.stringify options}"

  locationUrl: (format, options) ->
    "#{baseUrl}typeahead.#{format}?#{qs.stringify options}"

  # Send requests
  get: (url, fn) ->
    options = { url, json: true }

    request options, (err, response, body) ->
      if not err and body.StatusCode isnt 0
        err = "#{body.StatusCode} #{body.Message}"

      fn.call body, err, body.ResponseData if fn?
