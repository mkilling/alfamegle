$(document).ready ->
  socket: new io.Socket 'localhost'
  socket.connect()
  socket.send 'some data'
  socket.addEvent 'message', (data) ->
    alert 'got some data' + data;
