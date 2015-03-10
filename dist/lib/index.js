(function() {
  var SL, request, _;

  _ = require('lodash');

  request = require('./request');

  SL = (function() {
    function SL(config) {
      if (!config.key) {
        throw new Error('API key required');
      }
      this.format = config.format || 'json';
    }

    SL.prototype.realtimeInformation = function(options, fn) {
      var url, _ref;
      if (_.isFunction(options)) {
        _ref = [options, null], fn = _ref[0], options = _ref[1];
      }
      url = request.realtimeUrl(this.format, options);
      return request.get(url, fn);
    };

    SL.prototype.locationLookup = function(options, fn) {
      var url, _ref;
      if (_.isFunction(options)) {
        _ref = [options, null], fn = _ref[0], options = _ref[1];
      }
      url = request.locationUrl(this.format, options);
      return request.get(url, fn);
    };

    return SL;

  })();

  module.exports = SL;

}).call(this);
