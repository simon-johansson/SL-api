
SL = require './src/index.coffee'

keys =
  realtimeInformation: '93d670b5a250442baca4896869e40949'
  locationLookup: '7e219fc7f11340ff8a02ec6e1957765c'
  tripPlanner: 'f88b2c8432ea4a259fc831966a4e6262'
  trafficSituation: '9c2ba7f094694f959eb1648cf39cc6bf'
  disturbanceInformation: '0f1ddd492759449ab3218af8c6438d40'

sl = new SL keys

clb = (err, res) ->
  if err then throw new Error err
  console.log res

tripClb = (err, res) ->
  if err then throw new Error err
  console.log res
  # console.log res.TripList.Trip[0].LegList.Leg[0]

# console.log sl.realtimeInformation
# sl.realtimeInformation {siteid: 9507}, clb
# sl.realtimeInformation {siteid: 'werwfsdf'}, clb
# sl.locationLookup {}, clb
# sl.locationLookup {searchstring: "rådmansgatan"}, clb

# sl.realtimeInformation.get {siteid: 9507}, clb
# sl.disturbanceInformation.deviations {transportMode: "metro"}, clb
# sl.disturbanceInformation.deviations clb
# sl.disturbanceInformation.deviationsRawData clb
# sl.trafficSituation.get clb
# sl.tripPlanner.trip {originId: 9118, destId: 66666666}, clb
# sl.tripPlanner.trip {originId: 9118, destId: 9507}, tripClb
# sl.tripPlanner.journeyDetail {}, clb
# sl.tripPlanner.geometry {}, clb
