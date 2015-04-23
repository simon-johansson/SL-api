# SL-api

[![NPM version][npm-image]][npm-url] [![Build Status][travis-image]][travis-url] [![Coverage Status][coveralls-image]][coveralls-url] [![Dependency Status][daviddm-image]][daviddm-url]

<!-- [![Code Climate][codeclimate-image]][codeclimate-url]  -->

> Node.js wrapper for working with the official Storstockholms Lokaltrafiks (SL) public API:s

**[Install](#install)** <br>
**[Usage](#usage)** <br>
&nbsp;&nbsp; [Instantiation](#instantiation) <br>
**[Methods](#methods)** <br>
&nbsp;&nbsp; [.realtimeInformation](#realtimeinformation) <br>
&nbsp;&nbsp; [.locationLookup](#locationlookup) <br>
&nbsp;&nbsp; [.trafficSituation](#trafficsituation) <br>
&nbsp;&nbsp; [.disturbanceInformation](#disturbanceinformation) <br>
&nbsp;&nbsp; [.tripPlanner](#tripplanner) <br>
**[Tests](#tests)** <br>
**[Why is this module needed?](#why-is-this-module-needed)** <br>
**[Can this module be used in the browser?](#can-this-module-be-used-in-the-browser)** <br>

## Install

Install the module using [npm](https://npmjs.org) (npm is a packet manager and is included when installing [Node.js](https://nodejs.org/)).

```sh
$ npm install sl-api --save
```

Head over to [trafiklab.se](https://www.trafiklab.se), sign up/in and create a project to get your API keys.

## Usage

### Instantiation

Initialize an API client using the keys for your project. You do not have to supply keys for all the API:s, only for the ones you are planning to use.

```js
var SL = require('sl-api');

var sl = new SL({
  realtimeInformation: "<key for: SL Realtidsinformation 3>",
  locationLookup: "<key for: SL Platsuppslag>",
  tripPlanner: "<key for: SL Reseplanerare 2>",
  trafficSituation: "<key for: SL Trafikläget 2>",
  disturbanceInformation: "<key for: SL Störningsinformation 2>",
});
```

Pass an optional second argument to get the responses in raw ``json`` or ``xml`` format.

```js
var sl = new SL({
  realtimeInformation: "93d670b5a270442baca4896869e40949",
  locationLookup: "7e219fc7f11340ff5a02ec6e1957765c",
}, 'json');
```

## Methods

All methods accept an optional options object as the first argument which will modify the query string for the request.

```js
sl.realtimeInformation({siteid: 9507})
// api.sl.se/api2/realtimedepartures.json?key=<API KEY>&siteid=9507

sl.tripPlanner.trip({originId: 9118, destId: 9507})
// api.sl.se/api2/realtimedepartures.json?key=<API KEY>&originId=9118&destId=9507
```

All methods return promises but also accept a callback.

..use the promise...

```js
sl.realtimeInformation({siteid: 9507})
  .then(console.log)
  .fail(console.error)
  .done();

// promises are easily chainable
sl.locationLookup({searchstring: "tegnergatan"})
  .then(function (data) {
    return sl.realtimeInformation({siteid: data[0].SiteId});
  })
  .then(function (data) {
    data.Buses.forEach(function (bus) {
      console.log('towards %s in %s', bus.Destination, bus.DisplayTime);
    });
  })
  .fail(console.error)
  .done();
```

..or use a callback.

```js
sl.locationLookup(function(err, results) {
  if (err) {
    return console.error(err);
  }
  console.log(results);
});
```

### .realtimeInformation

> Get realtime departure information about buses, metros, trains, trams and ships for the specified site. Response also includes disturbance information.

Uses API key for [SL Realtidsinformation 3](https://www.trafiklab.se/api/sl-realtidsinformation-3)

```js
// example
sl.realtimeInformation({siteid: 9507}, callback);
```

### .locationLookup

> Get information about stations and location by searching for them by name.

Uses API key for [SL Platsuppslag](https://www.trafiklab.se/api/sl-platsuppslag)

```js
// example
sl.locationLookup({searchstring: "tegnerg"}, callback);
```

### .trafficSituation

> Get the current traffic situation.

<!-- Med detta API kan du få information om den aktuella statusen för SLs trafikläge. Detta är information på en övergripande nivå om aktuell status för respektive trafikslag. -->

Uses API key for [SL Trafikläget 2](https://www.trafiklab.se/api/sl-trafiklaget-2)

```js
// example
sl.trafficSituation(callback);
```

### .disturbanceInformation

> Get information about current and planned disturbances. Possible to specify a particular line or mode of transport.

Uses API key for [SL Störningsinformation 2](https://www.trafiklab.se/api/sl-storningsinformation-2)

**.deviations()**
```js
// example
sl.disturbanceInformation.deviations({transportMode: "metro"}, callback);
```

**.deviationsRawData()**
```js
// example
sl.disturbanceInformation.deviationsRawData({transportMode: "metro"}, callback);
```


### .tripPlanner

> Get proposals and information about trips from point A to B.

Uses API key for [SL Reseplanerare 2](https://www.trafiklab.se/api/sl-reseplanerare-2)

**.trip()**
```js
// example
sl.tripPlanner.trip({originId: 9118, destId: 9507}, callback);
```
**.journeyDetail()**
```js
// example
sl.tripPlanner.journeyDetail({ref: '202422%2F82420%2F794926%2F329989%2F74%3Fdate%3D2014-10-27%26station_evaId%3D400112174%26station_type%3Ddep%26lang%3Dsv%26format%3Dxml%26'}, callback);
```
**.geometry()**
```js
// example
sl.tripPlanner.geometry({ref: '348279%2F123375%2F748780%2F258298%2F74%26startIdx%3D18%26endIdx%3D20%26lang%3Dsv%26format%3Dxml%26'}, callback);
```

## Tests

```sh
# clone this repo
$ npm install
$ npm test
```
## Why is this module needed?

This is a convenience module that makes it easier to work with SLs API and attempts to iron out some of the quirks in the response data. For example, a response from the *Geometry* endpoint of the *Reseplanerare 2* API looks like this without the module:

```
"Geometry": {
  "Points": {
    "Point": [{
      "lat": "59.342954",
      "lon": "18.045853"
      }, {
      "lat": "59.341426",
      "lon": "18.044829"
      }, {
      "lat": "59.341426",
      "lon": "18.044829"
      },
      …
    ]
  }
}
```
But with the module you’ll get the array of points directly.

## Can this module be used in the browser?

No. The APIs does not support [JSON-P](https://kundo.se/org/trafiklabse/d/jsonp-cors/).

## License

MIT © [Simon Johansson](mailto:mail@simon-johansson.com)

[npm-image]: https://badge.fury.io/js/SL-api.svg
[npm-url]: https://npmjs.org/package/SL-api
[travis-image]: https://travis-ci.org/simon-johansson/SL-api.svg?branch=master
[travis-url]: https://travis-ci.org/simon-johansson/SL-api
[coveralls-image]: https://coveralls.io/repos/simon-johansson/SL-api/badge.svg?branch=master
[coveralls-url]: https://coveralls.io/r/simon-johansson/SL-api?branch=master
[daviddm-image]: https://david-dm.org/simon-johansson/SL-api.svg?theme=shields.io
[daviddm-url]: https://david-dm.org/simon-johansson/SL-api
<!-- [codeclimate-image]: https://codeclimate.com/github/simon-johansson/SL-api/badges/gpa.svg -->
<!-- [codeclimate-url]: https://codeclimate.com/github/simon-johansson/SL-api -->
