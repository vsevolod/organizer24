Organizer
  .controller 'CalendarCtrl', ['$state', '$filter', '$rootScope', '$stateParams', '$scope', 'Worker', 'Appointment', ($state, $filter, $rootScope, $stateParams, $scope, Worker, Appointment) ->

    $scope.minDate=new Date()
    $scope.date = new Date()
    $scope.currentAppointments = {} # Выбранные записи
    $scope.workers = Worker.query({}) # Мастера => Сервисы
    $scope.events = []

    ######### Временно для теста ###############
    #$scope.events = [{
    #  title: 'Test title'
    #  type: 'info'
    #  starts_at: moment("2015-03-17 12:00")
    #  ends_at: moment("2015-03-17 14:30")
    #  editable: false
    #  deletable: false
    #}]
    $scope.$watch 'date', (value, sv) ->
      console.log(value, sv)
      if value
        Appointment.query({date: value}).then( (appointments) ->
          $scope.events = appointments
        )
    $scope.eventClicked = ($event) ->
      console.log($event)
    ############################################

    $scope.workers.then (results) ->
      $scope.workers = results
      $scope.workers[0].services[0].checked = true # Временно для теста
      $scope.workers[1].services[0].checked = true # Временно для теста
      $scope.recountServices()

    $scope.recountServices = () ->
      _.each $scope.workers, (worker) ->
        $scope.currentAppointments[worker.id] = $filter('filter')(worker.services, {checked: true})

    $scope.removeService = (worker_id, service) ->
      $filter('getObjectByKeyValue')($filter('getObjectByKeyValue')($scope.workers, 'id', worker_id).services, 'id', service.id).checked = false
      $scope.recountServices()

  ]
