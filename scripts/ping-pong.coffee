module.exports = (robot) ->
  robot.respond /PING-PONG$/i, (msg) ->
    authdata = new Buffer('shopify'+':'+'moneyhats!').toString('base64')
    robot.http("https://ancient-beyond-4567.herokuapp.com/rooms/1.json").header('Authorization', authdata).get() (err, res, body) ->
      message.send "Room is " + body["isFree"]