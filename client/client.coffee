tojson: JSON.stringify
fromjson: JSON.parse
ctr: window.webkitNotifications

controls: -> $("#controls *")
disable: (controls) -> controls.attr "disabled", "disabled"
enable: (controls) -> controls.removeAttr "disabled"

notify: (title, text)->
  if ctr.checkPermission() is 0
    notification: ctr.createNotification(null, title, text)
    notification.show()

announce: (text) ->
  new_msg: $("<div>").addClass("announcement").text(text)
  $('#chatwindow').append new_msg

message: (you, msg) ->
  if not you then notify "Stranger", msg
  prefix: if you then "You:" else "Stranger:"
  prefix_class: if you then "mymessage" else "strangermessage"
  
  new_msg: $("<div>").addClass("announcement").
              append($("<div>").text(prefix).addClass(prefix_class)).
              append($("<div>").text(msg).addClass("message"))
  $('#chatwindow').append new_msg
  
handle_message: (data) ->
  switch data.type
    when "connect"
      enable controls()
      announce "You're now chatting with a random stranger. Say hey!"
    when "disconnect"
      disable controls()
      announce "disconnected :("
    when "message"
      message data.you, data.msg

$(document).ready ->
  disable controls()
  
  switch ctr?.checkPermission()
    when 1, 2 then ctr.requestPermission notify

  socket: new io.Socket null, {rememberTransport: false, port: 8080}
  socket.connect()
  socket.send tojson {'type': 'wantpartner'}
  socket.addEvent 'message', (data) -> handle_message fromjson data

  $('#disconnectbtn').click ->
    socket.send tojson {'type': 'wantdisconnect'}

  $('#sendbtn').click ->
    if $('#textarea').val().length > 0
      socket.send tojson {'type': 'message', 'msg': $('#textarea').val()}
      $('#textarea').val("").focus()
