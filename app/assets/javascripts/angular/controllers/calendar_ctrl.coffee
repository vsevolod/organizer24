Organizer
  .controller 'CalendarCtrl', ['$state', '$rootScope', '$stateParams', '$scope', 'Worker', ($state, $rootScope, $stateParams, $scope, Worker) ->

    $scope.workers = Worker.query({})

    $scope.workers.then (results) ->
      $scope.workers = results

  ]
