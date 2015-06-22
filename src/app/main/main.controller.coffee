angular.module "coffeegraph"
  .controller "MainController", ($timeout, toastr, $scope, financeData) ->
    $scope.period = 'Max'
    $scope.dataType = 'High'
    $scope.dataTypes = financeData.dataTypes
    $scope.periods = financeData.periods
    
    reloadData = ->
      financeData
        .get $scope.period, $scope.dataType
        .then (data) ->
          $scope.graphData = data
    
    $scope.changeDataType = (name) ->
      $scope.dataType = name
      reloadData()
    
    $scope.changePeriod = (name) ->
      $scope.period = name
      reloadData()
      
    $scope.$watch 'period', ->
      reloadData()
    
    reloadData()
    return
