Organizer.config(["$httpProvider", "$stateProvider", "$urlRouterProvider", ($httpProvider, $stateProvider, $urlRouterProvider) ->
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
  $urlRouterProvider
    .otherwise("/modal")

  $stateProvider
    .state('/', {
      url: ''
      templateUrl: 'angular/templates/calendar.html'
      controller: 'CalendarCtrl'
    })
])
