$(document).ready ->
  socket: new io.Socket 'localhost'
  socket.connect()
  socket.send 'some data'
  socket.addEvent 'message', ->
    alert 'got some data' + data;
