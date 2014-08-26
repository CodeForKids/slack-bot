# Description:
#   A way to interact with the Google Images API.
#
# Commands:
#   hubot image me <query> - The Original. Queries Google Images for <query> and returns a random top result.
#   hubot animate me <query> - The same thing as `image me`, except adds a few parameters to try to return an animated GIF instead.
#   hubot mustache me <url> - Adds a mustache to the specified URL.
#   hubot mustache me <query> - Searches Google Images for the specified query and mustaches it.

module.exports = (robot) ->
  robot.respond /(image|img)( me)? (.*)/i, (msg) ->
    imageMe msg, msg.match[3], (url) ->
      msg.send url

  robot.respond /animate( me)? (.*)/i, (msg) ->
    imageMe msg, msg.match[2], true, (url) ->
      msg.send url

  robot.respond /(?:mo?u)?sta(?:s|c)he?(?: me)? (.*)/i, (msg) ->
    type = Math.floor(Math.random() * 6)
    mustachify = "http://mustachify.me/#{type}?src="
    imagery = msg.match[1]

    if imagery.match /^https?:\/\//i
      msg.send "#{mustachify}#{imagery}"
    else
      imageMe msg, imagery, false, true, (url) ->
        msg.send "#{mustachify}#{url}"

  robot.respond /l(o+n+)gcat/i, (msg) ->
    msg.send "https://cdn.shopify.com/s/files/1/0249/1421/products/longcat1_grande.jpg"
    n = msg.match[1].length
    setTimeout ->
      for i in [1..n] by 2
        msg.send "https://cdn.shopify.com/s/files/1/0249/1421/products/longcat2_grande.jpg"
      setTimeout ->
        msg.send "https://cdn.shopify.com/s/files/1/0249/1421/products/longcat3_grande.jpg"
      , 500
    , 500

  robot.respond /l(o+n+)gburger/i, (msg) ->
    msg.send "http://cdn.shopify.com/s/files/1/0204/5572/files/tumblr_lsi8p2gloz1qaqsoco1_500_2014-07-02_12-38-30_2014-07-02_12-38-46.jpg"
    n = msg.match[1].length
    setTimeout ->
      for i in [1..n] by 2
        msg.send "http://cdn.shopify.com/s/files/1/0204/5572/files/tumblr_lsi8p2gloz1qaqsoco1_500_2014-07-02_12-36-21_2014-07-02_12-37-35.jpg"
        msg.send "http://cdn.shopify.com/s/files/1/0204/5572/files/tumblr_lsi8p2gloz1qaqsoco1_500_2014-07-02_12-35-49_2014-07-02_12-36-16.jpg"
        msg.send "http://cdn.shopify.com/s/files/1/0204/5572/files/tumblr_lsi8p2gloz1qaqsoco1_500_2014-07-02_12-35-14_2014-07-02_12-35-44.jpg"
        msg.send "http://cdn.shopify.com/s/files/1/0204/5572/files/tumblr_lsi8p2gloz1qaqsoco1_500_2014-07-02_12-34-09_2014-07-02_12-34-51.jpg"
      setTimeout ->
        msg.send "http://cdn.shopify.com/s/files/1/0204/5572/files/tumblr_lsi8p2gloz1qaqsoco1_500_2014-07-02_12-33-26_2014-07-02_12-33-43.jpg"
      , 500
    , 500

imageMe = (msg, query, animated, faces, cb) ->
  cb = animated if typeof animated == 'function'
  cb = faces if typeof faces == 'function'
  q = v: '1.0', rsz: '8', q: query, safe: 'active'
  q.imgtype = 'animated' if typeof animated is 'boolean' and animated is true
  q.imgtype = 'face' if typeof faces is 'boolean' and faces is true
  msg.http('http://ajax.googleapis.com/ajax/services/search/images')
    .query(q)
    .get() (err, res, body) ->
      images = JSON.parse(body)
      images = images.responseData?.results
      if images?.length > 0
        image = msg.random images
        cb ensureImageExtension image.unescapedUrl

ensureImageExtension = (url) ->
  ext = url.split('.').pop()
  if /(png|jpe?g|gif)/i.test(ext)
    url
  else
    "#{url}#.png"
