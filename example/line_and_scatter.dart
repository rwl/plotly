import 'package:plotly/plotly.dart';

main() {
  var trace1 = {
    'x': [1, 2, 3, 4],
    'y': [10, 15, 13, 17],
    'mode': 'markers'
  };

  var trace2 = {
    'x': [2, 3, 4, 5],
    'y': [16, 5, 11, 10],
    'mode': 'lines'
  };

  var trace3 = {
    'x': [1, 2, 3, 4],
    'y': [12, 9, 15, 12],
    'mode': 'lines+markers'
  };

  var data = [trace1, trace2, trace3];

  var layout = {'title': 'Line and Scatter Plot', 'height': 800, 'width': 960};

  var plot = new Plot.id('myDiv', data, layout);

  plot.onClick.listen((event) {
    print('click: $event');
  });
  plot.onHover.listen((event) {
    print('hover: $event');
  });

  plot
      .on("plotly_beforeplot")
      .listen((event) => print("plotly_beforeplot: $event"));
  plot
      .on("plotly_afterplot")
      .listen((event) => print("plotly_afterplot: $event"));
  plot
      .on("plotly_beforeexport")
      .listen((event) => print("plotly_beforeexport: $event"));
}
