$ ->
  $('#service #collections.controls input').change ->
    cost = 0
    showing_time = 0
    $('#service #collections.controls input:checked').each ->
      cost += parseInt( $(this).data('cost') )
      showing_time += parseInt( $(this).data('showing_time') )
    $('#service #service_showing_time').val( showing_time )
    $('#service #service_cost').val( cost )
