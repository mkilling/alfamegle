tojson: JSON.stringify
fromjson: JSON.parse
ctr: window.webkitNotifications

controls: -> 
  $("#controls").children()
  
disable: (controls)->
  controls.attr "disabled", "disabled"

enable: (controls) ->
  controls.removeAttr "disabled"

notify: (title, text)->
  if ctr.checkPermission() is 0
    notification: ctr.createNotification(null, title, text)
    notification.show()

announce: (cssclass, text)->
  new_msg: $("<div>").addClass(cssclass).text(text)
  $('#chatwindow').append new_msg

handle_message: (data) ->
  switch data.type
    when "connect"
      enable controls()
      announce "announcement", "You're now chatting with a random stranger. Say hey!"
    when "disconnect"
      disable controls()
      announce "announcement", "disconnected :("
    when "message"
      cssclass: "strangermessage"
        
      if data.you
        cssclass: "mymessage"
        notify "Stranger", data.msg
        
      announce cssclass, data.msg

$(document).ready ->
  disable controls()
  
  switch ctr?.checkPermission()
    when 1, 2 then ctr.requestPermission notify

  socket: new io.Socket null, {rememberTransport: false, port: 8080}
  socket.connect()
  socket.send tojson {'type': 'wantpartner'}
  socket.addEvent 'message', (data) -> handle_message fromjson data

  $('#disconnectbtn').click ->
    socket.send tojson {'type': 'disconnect'}

  $('#sendbtn').click ->
    socket.send tojson {'type': 'message', 'msg': $('#textarea').val()}
    $('#textarea').val("").focus()
