angular.module('appointment.services', ['rails'])
  .factory 'Appointment', ['RailsResource', (RailsResource) ->

    class Appointment extends RailsResource
      @configure
        url: '/api/appointments'
        name: 'appointment'

  ]
