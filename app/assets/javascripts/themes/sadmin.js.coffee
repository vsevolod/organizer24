#= require first_js
#= require jquery
#= require jquery_ujs
#= require jquery-ui
#= require themes/sadmin/bootstrap
#= require themes/sadmin/validationEngine.min
#= require themes/sadmin/validationEngine-ru
#= require themes/sadmin/sparkline
#= require themes/sadmin/scroll
#= require themes/sadmin/icheck
#= require themes/sadmin/input-mask
#= require themes/sadmin/feeds
#= require themes/sadmin/functions
#= require themes/sadmin/select
#= require themes/sadmin/datetimepicker
#= require themes/sadmin/pirobox

#= require fullcalendar
#= require cocoon
#= require calendar_autocomplete
#= require organizations
#= require_self

$('input.phone, input[id$=phone]').mask('+79999999999')

$('.show_statuses').on 'ifClicked', 'input', ->
  $.get("/main/set_session?key=show_#{$(this).val()}&value=#{$(this).is(':checked')}", ->
    worker = $('#workers input:checked').val()
    $('#calendar').fullCalendar('removeEventSource', Organizer.old_event_source)
    $('#calendar').fullCalendar('addEventSource', show_checkboxes(worker))
    $('#calendar').fullCalendar('removeEvents').fullCalendar( 'refetchEvents' )
  )
