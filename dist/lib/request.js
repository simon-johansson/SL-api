(function() {
  var baseUrl, qs, request;

  qs = require('querystring');

  request = require('request');

  baseUrl = "http://api.sl.se/api2/";

  module.exports = {
    realtimeUrl: function(format, options) {
      return "" + baseUrl + "realtimedepartures." + format + "?" + (qs.stringify(options));
    },
    locationUrl: function(format, options) {
      return "" + baseUrl + "typeahead." + format + "?" + (qs.stringify(options));
    },
    get: function(url, fn) {
      var options;
      options = {
        url: url,
        json: true
      };
      return request(options, function(err, response, body) {
        if (!err && body.StatusCode !== 0) {
          err = "" + body.StatusCode + " " + body.Message;
        }
        if (fn != null) {
          return fn.call(body, err, body.ResponseData);
        }
      });
    }
  };

}).call(this);
