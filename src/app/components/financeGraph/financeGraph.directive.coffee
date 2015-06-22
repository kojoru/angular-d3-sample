angular.module 'coffeegraph'
  .directive 'financeGraph', (d3) ->
    margin =
      top: 20
      right: 20
      bottom: 30
      left: 50
    
    width = 400 - margin.left - margin.right
    
    height = 200 - margin.top - margin.bottom
      
    formatDate = d3.time
      .format '%d.%m'
    
    x = d3.time.scale()
      .range [0, width]
    
    y = d3.scale.linear()
      .range [height, 0]
    
    xAxis = d3.svg.axis()
      .scale x
      .orient "bottom"
      .ticks 5
      .tickFormat (d) -> formatDate(d)
      .innerTickSize 0
      .outerTickSize 0
    
    yAxis = d3.svg.axis()
      .scale y
      .orient "left"
      .ticks 3
      .innerTickSize 0
      .outerTickSize 0
    
    xGrid = d3.svg.axis()
      .scale x
      .orient 'top'
      .ticks 5
      .innerTickSize height
      .tickFormat (t) -> ''
    
    yGrid = d3.svg.axis()
      .scale y
      .ticks 3
      .orient 'right'
      .innerTickSize width
      .tickFormat (t) -> ''
    
    line = d3.svg.line()
      .interpolate "monotone"
      .x (d) -> x(d.date)
      .y (d) -> y(d.close)
      
    linkFunc = (scope, el, attr, vm) ->
      svg = d3.select el[0]
        .select "svg"
        .attr "width", width + margin.left + margin.right
        .attr "height", height + margin.top + margin.bottom
        .append "g"
        .attr "transform", "translate(" + margin.left + "," + margin.top + ")"
      
      scope.$watch 'graphData', (data) ->
        return unless data?
		  
        x.domain [d3.min(data, (d) -> d.date ), d3.max(data, (d) -> d.date )]
        y.domain [Math.floor(d3.min(data, (d) -> d.close )), d3.max(data, (d) -> d.close )]
      
        svg.selectAll '*'
          .remove()
        
        svg.append "g"
          .attr "class", "x grid axis"
          .attr "transform", "translate(0," + height + ")"
          .call xAxis
  
        svg.append "g"
          .attr "class", "y grid axis"
          .call yAxis
  
        svg.append "g"
          .attr "class", "x grid inner"
          .attr "transform", "translate(0," + height + ")"
          .call xGrid
  
        svg.append "g"
          .attr "class", "y grid inner"
          .call yGrid
        
        svg.append "path"
          .datum data
          .attr "class", "line"
          .attr "d", line
          
        svg.selectAll "circle"
          .data data
          .enter()
          .append "circle"
          .attr 'class', 'point'
          .attr 'cx', (d) -> x(d.date)
          .attr 'cy', (d) -> y(d.close)
          .attr 'r', 3
          
        svg.append "g"
          .attr 'class', 'texts'
          .selectAll 'text'
          .data data
          .enter()
          .append 'text'
          .attr 'x', (d) -> x(d.date)
          .attr 'y', (d) -> y(d.close) - 5
          .attr 'text-anchor', 'middle'
          .text (d) -> d.close.toFixed(2)
  
        
    directive =
      restrict: 'E'
      scope: 
        graphData: '=data'
      transclude: true
      template: '<svg class="finance-graph"></svg><div class="inside-finance-graph" ng-transclude></div>'
      link: linkFunc