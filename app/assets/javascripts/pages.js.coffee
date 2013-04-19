set_phone_mask = ->
  $('input[name$="[phone]"]').mask('+79999999999')

complete_mask = (el) ->
  phone = el.val().replace('_','')
  if phone.length == 12 && phone != el.data('old-phone')
    $.post( '/users/check_phone', { phone: phone }, (data) ->
      # Смотрим - загрузить окно входа или регистрации
      send_data = "remote=true&user[phone]="+phone
      url = if data == 'Exist' then 'sign_in' else 'sign_up'
      $.colorbox({
        href: '/users/'+url,
        data: send_data,
        onComplete: ->
          phone = $('#cboxWrapper input[name$="[phone]"]')
          phone.val(phone.data('old-phone').replace(/^ *\+*7/, '') )
          $('#cboxWrapper #user_password').focus()
      })
    )

set_keypress_on_phone = (el) ->
  # FIXME - change keypress to live(keypress, ... ?
  el.trigger('unmask').mask('+79999999999', {
    completed: ->
      complete_mask( $(this) )
  })


$ ->
  $('.carousel').carousel()

  set_phone_mask()
  $(document).bind('cbox_complete', ->
    set_phone_mask()
    set_keypress_on_phone( $('#cboxWrapper input[name$="[phone]"]') )
  )

  $("form.sign_in_index[colorbox='true']").submit ->
    complete_mask( $(this).find('#user_phone') )
    false
