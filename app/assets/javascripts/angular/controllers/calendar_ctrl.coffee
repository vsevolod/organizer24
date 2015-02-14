Organizer
  .controller 'CalendarCtrl', ['$state', '$filter', '$rootScope', '$stateParams', '$scope', 'Worker', ($state, $filter, $rootScope, $stateParams, $scope, Worker) ->

    $scope.currentAppointments = {}
    $scope.workers = Worker.query({})

    $scope.workers.then (results) ->
      $scope.workers = results

    $scope.recountServices = () ->
      _.each $scope.workers, (worker) ->
        $scope.currentAppointments[worker.id] = $filter('filter')(worker.services, {checked: true})

    $scope.removeService = (worker_id, service) ->
      $filter('getObjectByKeyValue')($filter('getObjectByKeyValue')($scope.workers, 'id', worker_id).services, 'id', service.id).checked = false
      $scope.recountServices()

  ]
