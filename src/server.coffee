Primus = require 'primus'
http = require 'http'
nodeStatic = require 'node-static'


server = http.createServer( (req, res) ->

  fileServer = new nodeStatic.Server './public'

  if req.url == '/'
    return fileServer.serveFile('/index.html', 200, {}, req, res);

  req.addListener 'end', () ->
    fileServer.serve req, res
  .resume()
)

primus = new Primus server, transformer: 'sockJS'

primus.on 'connection', (socket) ->
  console.log 'client' + socket.id + ' has connected to the server'
  socket.on 'data', (message) ->
    console.log 'received a message', message
    socket.write ping: 'pong'

server.listen 3000, '127.0.0.1'
console.log 'Server running at http://127.0.0.1:3000/'