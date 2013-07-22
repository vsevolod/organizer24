autocomplete_users = ->
  phone      = $('#first #user_phone').val().replace(/_+/, '')
  firstname  = $('#first #user_firstname').val().toLowerCase()
  lastname   = $('#first #user_lastname').val().toLowerCase()
  results    = []
  el         = null
  $('#phone_results').html('')
  $.each( phonebook, (index, el) ->
    unless el.firstname
      el.firstname = ''
    unless el.lastname
      el.lastname = ''
    if (el.phone.toLowerCase().indexOf(phone) == 0 && el.firstname.toLowerCase().indexOf(firstname) == 0 && el.lastname.toLowerCase().indexOf(lastname) == 0)
      results.push(el)
  )
  if (results.length != 0)
    if (results.length > 9)
      $('#phone_results').html('<span class="label label-important">'+results.length+'</span>')
    else
      $.each( results, (index, el) ->
        a = $("<a href='#' class='AutoPhoneClick'><span class='label'>#{el.phone} #{el.firstname} #{el.lastname}</span></a><a href='/users/#{el.phone}' target='_blank' class='label label-success'><i class='icon-eye-open icon-white'></i></a>").data({phone: el.phone, firstname: el.firstname, lastname: el.lastname})
        $('#phone_results').append($('<div class="span3"/>').append(a))
      )

Organizer.add_calendar_autocomplete = (phonebook) ->
  $.each(['firstname', 'phone', 'lastname'], (index, num) ->
    $('#first #user_'+num).keyup( ->
      autocomplete_users()
    )
  )
