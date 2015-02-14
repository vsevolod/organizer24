angular.module('hash.filter', [])
  # [{a: 1},{a: 2},{a: 3}] | getObjectByKeyValue:'a':3 return {a: 3}
  .filter 'getObjectByKeyValue', ->
    return (object_array, key, value) ->
      result = null
      _.each(object_array, (el) ->
        if el[key]+'' == value+''
          result = el
      )
      result
  # {a: 1, b: [2], c: [3, [4]]} | flattenValues return [1,2,3,4]
  .filter 'flattenValues', ->
    return (object_hash) ->
      _.flatten(_.values(object_hash))
