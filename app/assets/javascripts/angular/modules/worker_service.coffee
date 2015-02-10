angular.module('worker.services', ['rails'])
  .factory 'Worker', ['RailsResource', (RailsResource) ->

    class Worker extends RailsResource
      @configure
        url: '/api/workers'
        name: 'worker'

  ]
