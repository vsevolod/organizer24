$ ->
  if gon && gon.socket_options
    window.socket = io("http://localhost:8000")
    window.socket.emit('join', gon.socket_options)

    window.socket.on 'message', (fio, message) ->
      $.jGrowl("<b>#{fio}</b> #{message}",{sticky: true, header: '', position:'top-right'})

    window.socket.on 'refresh event', (appointment_id) ->
      $('#calendar').fullCalendar('refetchEvents')
