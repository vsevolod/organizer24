angular.module('date.filter', [])
  .filter 'showDuration', ->
    return (duration) ->
      hours = Math.floor(duration/60)
      minutes = Math.floor(duration%60)

      result = []
      result.push(moment.duration(hours, 'hours').humanize()) if hours > 0
      result.push(moment.duration(minutes, 'minutes').humanize()) if minutes > 0
      result.join(' ')
