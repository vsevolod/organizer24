$ ->
  if gon && gon.organization_id
    socket = io('http://localhost:8000')
    socket.emit('join', gon.organization_id, gon.user)

    socket.on 'message', (fio, message) ->
      console.log(fio, message)
      alert('asdf')
      $.jGrowl("<b>#{fio}</b> #{message}",{sticky: true, header: "", position:'bottom-right'})
