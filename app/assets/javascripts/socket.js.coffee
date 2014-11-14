$ ->
  if gon && gon.socket_options
    window.socket = io("http://organizer24.ru:8000")
    window.socket.emit('join', gon.socket_options)

    window.socket.on 'message', (fio, message) ->
      $.jGrowl("<b>#{fio}</b> #{message}",{sticky: true, header: '', position:'top-right'})

    window.socket.on 'refresh event', (options) ->
      worker_id = $('#workers input:checked').val()
      console.log('Options:', options)
      console.log('Worker:', worker_id, options.worker_id)
      if Number(worker_id) == options.worker_id
        if moment(options.start) >= $('#calendar').fullCalendar('getView').intervalStart && moment(options.start) <= $('#calendar').fullCalendar('getView').intervalEnd
          $('#calendar').fullCalendar('refetchEvents')
          console.log 'in list'
        else
          console.log 'not in list'
