$(document).ready ->
  # Sample scores visualization
  if $('#hiddendata-score').length
    scoreData = [ 'Sample Rating' ].concat $('#hiddendata-score').html().split(',')
    expectedData = Array.apply(null, Array(scoreData.length - 1)).map ->
      $('#sample_expected_score').val()

    expectedData = ['Expected Rating'].concat(expectedData)

    chart = c3.generate(
      bindto: '#chart-score',
      data: columns: [scoreData, expectedData]
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