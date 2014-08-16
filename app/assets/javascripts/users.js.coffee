plotAccordingToChoices = (flot_type) ->
  choiceContainer = $("##{flot_type}_choices")
  data = []
  choiceContainer.find('input:checked').each ->
    key = $(this).prop('name')
    if key && gon["#{flot_type}_dataset"][key]
      data.push(gon["#{flot_type}_dataset"][key])
  if data.length > 0
    $.plot("##{flot_type}", data, {
      yaxis: {min: 0}
      xaxis: {
        ticks: [[1, 'Январь'],[2, 'Февраль'],[3, 'Март'],[4,'Апрель'],[5,'Май'],[6,'Июнь'],[7,'Июль'],[8,'Август'],[9, 'Сентябрь'],[10,'Октябрь'],[11,'ноябрь'],[12,'Декабрь']]
      }
      series: {lines: {show: true}, points: {show: true}}
      grid: {hoverable: true}
    })
    $("##{flot_type}").bind('plothover', (event, pos, item) ->
      if item
        cost = item.series.data[item.dataIndex][2]
        x = item.datapoint[0].toFixed(2)
        y = item.datapoint[1].toFixed(2)
        $("#tooltip").html("Сумма: #{cost}").css({top: item.pageY+5, left: item.pageX+5}).fadeIn(200)
      else
        $('#tooltip').hide()
    )

$ ->
  if $('#statistic')[0]

    $('<div id="tooltip"></div>').css({
      position: 'absolute'
      display: 'none'
      border: '1px solid #fdd'
      padding: '2px'
      'background-color': '#fee'
      color: '#000'
      opacity: '0.8'
    }).appendTo('body')

    $.each ['appointments_flot', 'users_flot'], (index, flot_type) ->

      i = 0
      $.each(gon["#{flot_type}_dataset"], (k, v) ->
        v.color = i
        i++
      )

      choiceContainer = $("##{flot_type}_choices")
      $.each(gon["#{flot_type}_dataset"], (k,v) ->
        choiceContainer.append("<br/><input type='checkbox' name='#{k}' checked='checked' id='id#{k}'></input><label for='id#{k}'>#{v.label}</label>")
      )
      if $().iCheck
        choiceContainer.iCheck({
          checkboxClass: 'icheckbox_minimal',
          radioClass: 'iradio_minimal',
          increaseArea: '20%'
        })

      choiceContainer.on('click ifChanged', 'input', ->
        plotAccordingToChoices(flot_type)
      )
      plotAccordingToChoices(flot_type)
