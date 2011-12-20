http: require "http"
url: require "url"
fs: require "fs"
io: require "./vendor/Socket.IO-node/lib/socket.io"
sys: require "sys"

tojson: JSON.stringify
fromjson: JSON.parse

send404: (res) ->
  res.writeHead 404
  res.write '404'
  res.end()

server: http.createServer (req, res) ->
  path: (url.parse req.url).pathname;
  if path == "/" then path: "/index.html"
  filepath: __dirname + "/client" + path
  sys.puts filepath
  try
    res.writeHead 200, {'Content-Type': 'text/' + if path.substr(-3) == '.js' then 'js' else 'html'}
    res.write fs.readFileSync(filepath, 'utf8'), 'utf8'
    res.end()
    sys.puts "200: " + filepath
  catch err
    sys.puts "404: " + filepath
    send404 res

server.listen parseInt(process.argv[2] or "80", 10)

all_clients: []
find_partner: (client) ->
  if not client.room?
    for otherclient in all_clients when otherclient isnt client
      if not otherclient.room?
        put_into_room client, otherclient
        break

    setTimeout (find_partner <- null, client), 200

put_into_room: (clients...) ->
  for client in clients
    client.room: clients
    client.send tojson {"type": "connect"}
    client.send_to_others: send_to_others <- null, client

send_to_others: (client, message) ->
  for otherclient in client.room when otherclient isnt client
    otherclient.send message

disconnect: (client) ->
  if client.room?
    for c in client.room
      c.send tojson {"type": "disconnect"}
      c.room: undefined

io.listen server, {
  onClientConnect: (client) ->
    all_clients.push client

  onClientMessage: (message, client) ->
    sys.puts message
    msg: fromjson message
    switch msg.type
      when "message"
        if client.room?
          client.send tojson {"type": "message", "you": true, "msg": msg.msg}
          client.send_to_others tojson {"type": "message", "you": false, "msg": msg.msg}
      when "wantdisconnect"
        disconnect client
      when "wantpartner"
        find_partner client

  onClientDisconnect: (client) ->
    disconnect client
    all_clients: c for c in all_clients when c isnt client
}