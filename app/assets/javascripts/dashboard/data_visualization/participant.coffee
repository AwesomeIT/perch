$(document).ready ->
  # Participant scores visualization
  if $('#hiddendata-score-rating').length
    ratingData = [ 'Sample Rating' ].concat $('#hiddendata-score-rating').html().split(',')
    xData = ['x'].concat $('#hiddendata-score-id').html().split(',')

    chart = c3.generate(
      bindto: '#chart-score-participant',
      data: 
        x: 'x'
        columns: [ratingData, xData]
        type: 'scatter'
      axis:
        x:
          label:
            text: 'Score ID'
            position: 'outer-middle'
          tick: 
            type: 'timeseries'
            fit: true
        y:
          label:
            text: 'Rating'
            position: 'outer-middle'
    )
  return