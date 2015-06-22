angular.module 'coffeegraph'
  .factory 'financeData', (d3, $q) ->
    files =
      'Week': 'week.csv'
      'Month': 'month.csv'
      'Quarter': 'quarter.csv'
      'Year': 'year.csv'
      'Max': 'max.csv'
    
    dataTypes =
      'Open': 'Open'
      'High': 'High'
      'Low': 'Low'
      'Volume': 'Volume'
    
    parseDate = d3.time
      .format "%Y-%m-%d"
      .parse
    
    dataProvider =
      get: (period, datumName) ->
        deferred = $q.defer()
        d3.csv "/assets/data/"+files[period], (error, data) ->
          deferred.reject(error) if error?
  
          data.forEach (d) ->
            d.date = parseDate(d.Date)
            d.close = +d[dataTypes[datumName]]
          deferred.resolve(data)
        deferred.promise
          