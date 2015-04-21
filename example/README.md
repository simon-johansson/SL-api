#Example

1. Change the name of ``keys.json.exmaple`` to ``keys.json`` and fill in your keys. It will look something like this:

```json
{
  "realtimeInformation": "93d670b5a270442baca4896869e40949",
  "locationLookup": "7e219fc7f11340ff5a02ec6e1957765c",
  "tripPlanner": "f88b2c8432ea4a259fc431966a4e6262",
  "trafficSituation": "9c2ba7f094694f859eb1648cf39cc6bf",
  "disturbanceInformation": "0f1ddd495759449ab3218af8c6438d40"
}
```

2. Run ``npm run example`` to compile the lib from coffeescript and start the example app.

3. Visit [http://localhost:3000/](http://localhost:3000/) in your browser of choice.

###Endpoints

####/realtime/:siteid
Try searching for a station with ``/location/:query`` and use the ``siteid`` from the search.

[http://localhost:3000/realtime/9192](http://localhost:3000/realtime/9192) - departures from Slussen <br>
[http://localhost:3000/realtime/9001](http://localhost:3000/realtime/9001) - departures from T-Centralen

####/location/:query
[http://localhost:3000/location/rådmansg](http://localhost:3000/location/rådmansg) <br>
[http://localhost:3000/location/hötor](http://localhost:3000/location/hötor)

####/trip/:from/:to
[http://localhost:3000/trip/9118/9507](http://localhost:3000/trip/9118/9507) - Rådmansgatan → Helenelund <br>
[http://localhost:3000/trip/9500/3020](http://localhost:3000/trip/9500/3020) - Märsta → Drottningholm

####/traffic
[http://localhost:3000/traffic](http://localhost:3000/traffic)

####/disturbance
[http://localhost:3000/disturbance](http://localhost:3000/disturbance)



