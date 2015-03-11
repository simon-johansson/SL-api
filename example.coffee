
SL = require './src/lib/index.coffee'

keys =
  realtimeInformation: '93d670b5a250442baca4896869e40949'
  locationLookup: '7e219fc7f11340ff8a02ec6e1957765c'
  tripPlanner: 'f88b2c8432ea4a259fc831966a4e6262'

sl = new SL keys

clb = (err, res) ->
  if err then throw new Error err
  console.log res

tripClb = (err, res) ->
  if err then throw new Error err
  console.log res.TripList.Trip[0].LegList.Leg[0]

# sl.realtimeInformation.get {siteid: 'werwfsdf'}, clb
# sl.realtimeInformation.get {siteid: 9507}, clb
# sl.locationLookup.get {}, clb
# sl.locationLookup.get {searchstring: "rådmansgatan"}, clb
# sl.tripPlanner.trip {originId: 9118, destId: 66666666}, clb
# sl.tripPlanner.trip {originId: 9118, destId: 9507}, tripClb
# sl.tripPlanner.journeyDetail {}, clb
# sl.tripPlanner.geometry {}, clb

