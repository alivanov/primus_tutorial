Primus = require 'primus'
http = require 'http'
nodeStatic = require 'node-static'
fs = require 'fs'
lstream = require 'lstream'

server = http.createServer( (req, res) ->

  fileServer = new nodeStatic.Server './public'

  if req.url == '/'
    return fileServer.serveFile('/index.html', 200, {}, req, res);

  req.addListener 'end', () ->
    fileServer.serve req, res
  .resume()
)

primus = new Primus server, transformer: 'engine.io'

primus.on 'connection', (socket) ->
  console.log 'client' + socket.id + ' has connected to the server'
  fs.createReadStream './public/text.txt'
  .pipe new lstream()
  .pipe socket

  socket.on 'data', (message) ->
    console.log 'received a message', message

server.listen 3000, '127.0.0.1'
console.log 'Server running at http://127.0.0.1:3000/'