
SL = require './src/lib/index.coffee'

config =
  key: '93d670b5a250442baca4896869e40949' #required
  format: 'json' #json or xml - defaults to json
  # debug: true #generates meta object with StatusCode, Message, ExecutionTime, LatestUpdate & DataAge - defaults to false

sl = new SL config

realtimeOptions =
  siteid: 9507
  timewindow: 0 #0-60 - defaults to 0

sl.realtimeInformation realtimeOptions, (err, response) ->
  if err then throw new Error err
  console.log response

locationOptions =
  searchstring: ""
  stationsonly: true #defaults to true
  maxresults: 10 ##defaults to 10, max 50

sl.locationLookup locationOptions, (err, response) ->
  if err then throw new Error err
  console.log response

# sl.getDepartures {site_id: 9507, transport_mode: 'train'}, (err, response) ->
#   if err then throw new Error err
#   console.log response

