var path = require('path');
var util = require('util');
var express = require('express');
var app = express();

var SL = require('../dist/lib/');
var sl = new SL(require('./keys'));

app.set('port', process.env.PORT || 3000);
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

app.get('/', function(req, res) {
  res.render('index');
});

app.get('/*', function(req, res, next) {
  res.header("Content-Type", "text/plain; charset=utf-8");
  next();
});

app.get('/realtime/:siteid', function (req, res) {

  function parseDepartures (data) {
    var fn = function (vehicle) {
      var location = data[vehicle][0] ? data[vehicle][0].StopAreaName : void 0;
      if(location) {
        return vehicle + ' from ' + location + ":\n" + data[vehicle].map(function (el) {
          return util.format('%s \t %s \t to: %s',
            el.DisplayTime, (el.GroupOfLine && el.GroupOfLine !== 'blåbuss' ? el.GroupOfLine + ' ' + el.LineNumber : el.LineNumber), el.Destination);
        }).join('\n');
      }
    };
    return [fn('Buses'), fn('Metros'), fn('Trains'), fn('Trams'), fn('Ships')].join("\n\n");
  }

  sl.realtimeInformation({siteid: req.params.siteid})
    .then(function (data) {
      res.send(parseDepartures(data));
    })
    .fail(function (err) {
      res.send(err);
    });
});

app.get('/location/:query', function (req, res) {

  function parseLocations (data) {
    return data.map(function (el) {
      return util.format('Name: %s\nSiteId: %s\nType: %s\nX: %s\nY: %s', el.Name, el.SiteId, el.Type, el.X, el.Y);
    }).join('\n\n');
  }

  sl.locationLookup({searchstring: req.params.query})
    .then(function (data) {
      res.send(parseLocations(data));
    })
    .fail(function (err) {
      res.send(err);
    });
});

app.get('/trip/:from/:to', function (req, res) {

  function parseTrip (data) {
    var str = "";
    data.forEach(function (trip) {
      str += trip.LegList.Leg.map(function (leg) {
        return util.format('%s %s (%s mot %s) -> %s %s',
          leg.Origin.time, leg.Origin.name, leg.name, (leg.dir ? leg.dir : leg.Destination.name), leg.Destination.time, leg.Destination.name);
      }).join('\n') + '\n\n';
    });
    return str;
  }

  sl.tripPlanner.trip({originId: req.params.from, destId: req.params.to})
    .then(function (data) {
      res.send(parseTrip(data));
    })
    .fail(function (err) {
      res.send(err);
    });
});

app.get('/traffic', function (req, res) {

  function parseTraffic (data) {
    var str = "";
    data.forEach(function (el) {
      str += el.Name + ":\n" + el.Events.map(function (ev) {
        return ev.Message;
      }).join('\n') + "\n\n";
    });
    return str;
  }

  sl.trafficSituation()
    .then(function (data) {
      res.send(parseTraffic(data));
    })
    .fail(function (err) {
      res.send(err);
    });
});

app.get('/disturbance', function (req, res) {

  function parseDeviations (data) {
    var str = "";
    data.forEach(function (el) {
      str += el.Header + "\n" + el.Details + "\n\n";
    });
    return str;
  }

  sl.disturbanceInformation.deviations()
    .then(function (data) {
      res.send(parseDeviations(data));
    })
    .fail(function (err) {
      res.send(err);
    });
});

app.listen(app.get('port'), function () {
  console.log('\nExamples are now available at http://localhost:' + app.get('port'));
});
