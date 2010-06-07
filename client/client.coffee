json: JSON.stringify

$(document).ready ->
  socket: new io.Socket null, {rememberTransport: false, port: 8080}
  socket.connect()
  socket.addEvent 'message', (data) ->
    new_msg: $("<div class='announcement'></div>").text data
    $('#chatwindow').append new_msg

  $('#disconnectbtn').click ->
    socket.send json {'type': 'disconnect'}

  $('#sendbtn').click ->
    socket.send json {'type': 'message', 'msg': $('#textarea').val()}
