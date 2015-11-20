library plotly;

import 'dart:js';

class Plot {
  JsObject _Plotly, _plot;
  Plot(container, data, Map<String, dynamic> layout,
      {bool showLink: false,
      bool staticPlot,
      String linkText,
      bool displaylogo: false,
      bool displayModeBar,
      bool scrollZoom}) {
    _Plotly = context['Plotly'];
    var _data = new JsObject.jsify(data);
    var _layout = new JsObject.jsify(layout);
    var opts = {};
    if (showLink != null) opts['showLink'] = showLink;
    if (staticPlot != null) opts['staticPlot'] = staticPlot;
    if (linkText != null) opts['linkText'] = linkText;
    if (displaylogo != null) opts['displaylogo'] = displaylogo;
    if (displayModeBar != null) opts['displayModeBar'] = displayModeBar;
    if (scrollZoom != null) opts['scrollZoom'] = scrollZoom;
    var _opts = new JsObject.jsify(opts);
    _plot = _Plotly.callMethod('newPlot', [container, _data, _layout, _opts]);
  }
}
