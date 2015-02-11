Organizer
  .controller 'CalendarCtrl', ['$state', '$filter', '$rootScope', '$stateParams', '$scope', 'Worker', ($state, $filter, $rootScope, $stateParams, $scope, Worker) ->

    $scope.currentAppointments = {}
    $scope.workers = Worker.query({})

    $scope.workers.then (results) ->
      $scope.workers = results

    $scope.toggleService = (service) ->
      _.each $scope.workers, (worker) ->
        $scope.currentAppointments[worker.id] = $filter('filter')(worker.services, {checked: true})
      #index = _.indexOf($scope.currentAppointments, service)
      #if index >= 0
      #  $scope.currentAppointments.splice(index, 1)
      #else
      #  $scope.currentAppointments.push(service)


  ]
