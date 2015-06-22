angular.module "coffeegraph"
  .controller "MainController", ($timeout, toastr, $scope, financeData) ->
    res = financeData.get('Week', 'High')
    res.then (data) ->
      $scope.graphData = data
    return
