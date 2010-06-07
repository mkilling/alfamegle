http: require "http"
url: require "url"
fs: require "fs"
io: require "./lib/socket.io"
sys: require "sys"

send404: (res) ->
  res.writeHead 404
  res.write '404'
  res.end()

server: http.createServer (req, res) ->
  path: (url.parse req.url).pathname;
  filepath: __dirname + "/client" + path
  try
    res.writeHead 200, {'Content-Type': 'text/html'}
    res.write fs.readFileSync(filepath, 'utf8'), 'utf8'
    res.end()
  catch err
    sys.puts "404: " + filepath
    send404 res

server.listen 8080

json: JSON.stringify

io.listen server, {
  onClientConnect: (client) ->
    sys.puts "connected!"
    client.send json { buffer: "buffer" }
}