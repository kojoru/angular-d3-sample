angular.module 'coffeegraph'
  .directive 'graph', (d3) ->
    margin =
      top: 20
      right: 20
      bottom: 30
      left: 50
    
    width = 960 - margin.left - margin.right
    
    height = 500 - margin.top - margin.bottom
    
    parseDate = d3.time
      .format "%Y-%m-%d"
      .parse
    
    x = d3.time.scale()
      .range [0, width]
    
    y = d3.scale.linear()
      .range [height, 0]
    
    xAxis = d3.svg.axis()
      .scale x
      .orient "bottom"
      .ticks 5
    
    yAxis = d3.svg.axis()
      .scale y
      .orient "left"
      .ticks 3
    
    line = d3.svg.line()
      .interpolate "monotone"
      .x (d) -> x(d.date)
      .y (d) -> y(d.close)
      
    linkFunc = (scope, el, attr, vm) ->
      svg = d3.select el[0]
        .append "svg"
        .classed 'finance-graph', true
        .attr "width", width + margin.left + margin.right
        .attr "height", height + margin.top + margin.bottom
        .append "g"
        .attr "transform", "translate(" + margin.left + "," + margin.top + ")"
      
      d3.csv "/assets/data/year.csv", (error, data) ->
        throw error if error?

        data.forEach (d) ->
          d.date = parseDate(d.Date)
          d.close = +d.Close
		  
        x.domain d3.extent(data, (d) -> d.date )
        y.domain d3.extent(data, (d) -> d.close )
      
        svg.append "g"
          .attr "class", "x axis"
          .attr "transform", "translate(0," + height + ")"
          .call xAxis
  
        svg.append "g"
          .attr "class", "y axis"
          .call yAxis
  
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
      link: linkFunc