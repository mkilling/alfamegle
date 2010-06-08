json: JSON.stringify
ctr: window.webkitNotifications

notify: ->
  if ctr.checkPermission() is 0
    notification: ctr.createNotification(null, "hello", "world")
    notification.show()

$(document).ready ->
  socket: new io.Socket null, {rememberTransport: false, port: 8080}
  socket.connect()
  socket.addEvent 'message', (data) ->
    new_msg: $("<div class='announcement'></div>").text data
    $('#chatwindow').append new_msg

  $('#disconnectbtn').click ->
    socket.send json {'type': 'disconnect'}
    switch ctr?.checkPermission()
      when 0 then notify()
      when undefined then
      else ctr.requestPermission notify

  $('#sendbtn').click ->
    socket.send json {'type': 'message', 'msg': $('#textarea').val()}
