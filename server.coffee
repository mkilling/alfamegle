http: require "http"
url: require "url"
fs: require "fs"
io: require "./lib/socket.io"
sys: require "sys"

server: http.createServer (req, res) ->
  res.writeHead 200, {'Content-Type': 'text/html'}
  res.write '<h1>Welcome</h1>'
  res.end()

server.listen 8080