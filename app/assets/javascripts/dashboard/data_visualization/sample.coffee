$(document).ready ->
  # Sample scores visualization
  if $('#hiddendata-rating').length
    ratingData = [ 'Sample Rating' ].concat $('#hiddendata-rating').html().split(',')
    xData = ['x'].concat $('#hiddendata-id').html().split(',')

    chart = c3.generate(
      bindto: '#chart-score'
      data: 
        x: 'x'
        columns: [ratingData, xData]
        type: 'scatter'
      axis:
        x:
          label:
            text: 'Score ID'
            position: 'outer-middle'
        y:
          label:
            text: 'Rating'
            position: 'outer-middle'
    )
  return