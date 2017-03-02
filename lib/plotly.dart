library plotly;

import 'dart:html';
import 'dart:js';
import 'dart:async';

/// Interactive scientific chart.
class Plot {
  final JsObject _Plotly;
  final Element _container;
  final JsObject _proxy;

  /// Create a new plot in an empty `<div>` element.
  ///
  /// A note on sizing: You can either supply height and width in layout, or
  /// give the `div` a height and width in CSS.
  Plot(Element container, List data, Map<String, dynamic> layout,
      {bool showLink: false,
      bool staticPlot,
      String linkText,
      bool displaylogo: false,
      bool displayModeBar,
      bool scrollZoom})
      : _Plotly = context['Plotly'],
        _container = container,
        _proxy = new JsObject.fromBrowserObject(container) {
    if (_Plotly == null) {
      throw new StateError('plotly.min.js no loaded');
    }
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
    _Plotly.callMethod('newPlot', [_container, _data, _layout, _opts]);
  }

  /// Create a new plot in an empty `<div>` element with the given id.
  ///
  /// A note on sizing: You can either supply height and width in layout, or
  /// give the `div` a height and width in CSS.
  factory Plot.id(String id, List data, Map<String, dynamic> layout,
      {bool showLink: false,
      bool staticPlot,
      String linkText,
      bool displaylogo: false,
      bool displayModeBar,
      bool scrollZoom}) {
    var elem = document.getElementById(id);
    return new Plot(elem, data, layout,
        showLink: showLink,
        staticPlot: staticPlot,
        linkText: linkText,
        displaylogo: displaylogo,
        displayModeBar: displayModeBar,
        scrollZoom: scrollZoom);
  }

  /// Create a new plot in an empty `<div>` element with the given [selectors].
  ///
  /// A note on sizing: You can either supply height and width in layout, or
  /// give the `div` a height and width in CSS.
  factory Plot.selector(
      String selectors, List data, Map<String, dynamic> layout,
      {bool showLink: false,
      bool staticPlot,
      String linkText,
      bool displaylogo: false,
      bool displayModeBar,
      bool scrollZoom}) {
    var elem = document.querySelector(selectors);
    return new Plot(elem, data, layout,
        showLink: showLink,
        staticPlot: staticPlot,
        linkText: linkText,
        displaylogo: displaylogo,
        displayModeBar: displayModeBar,
        scrollZoom: scrollZoom);
  }

  get data => _proxy['data'];
  get layout => _proxy['layout'];

  Stream get onClick => on("plotly_click");
  Stream get onBeforeHover => on("plotly_beforehover");
  Stream get onHover => on("plotly_hover");
  Stream get onUnhover => on("plotly_unhover");

  Stream on(String eventType) {
    var ctrl = new StreamController();
    _proxy.callMethod('on', [eventType, ctrl.add]);
    return ctrl.stream;
  }

  /// An efficient means of changing parameters in the data array. When
  /// restyling, you may choose to have the specified changes effect as
  /// many traces as desired. The update is given as a single [Map] and
  /// the traces that are effected are given as a list of traces indices.
  /// Note, leaving the trace indices unspecified assumes that you want
  /// to restyle *all* the traces.
  void restyle(Map aobj, [List<int> traces]) {
    var args = [_container, new JsObject.jsify(aobj)];
    if (traces != null) {
      args.add(new JsObject.jsify(traces));
    }
    _Plotly.callMethod('restyle', args);
  }

  /// An efficient means of updating just the layout of a plot.
  void relayout(Map aobj) {
    _Plotly.callMethod('relayout', [_container, new JsObject.jsify(aobj)]);
  }

  /// Add a new trace to an existing plot at any location in its data array.
  void addTrace(Map trace, [int newIndex]) {
    if (newIndex != null) {
      addTraces([trace], [newIndex]);
    } else {
      addTraces([trace]);
    }
  }

  /// Add new traces to an existing plot at any location in its data array.
  void addTraces(List<Map> traces, [List<int> newIndices]) {
    var args = [_container, new JsObject.jsify(traces)];
    if (newIndices != null) {
      args.add(new JsObject.jsify(newIndices));
    }
    _Plotly.callMethod('addTraces', args);
  }

  /// Remove a trace from a plot by specifying the index of the trace to be
  /// removed.
  void deleteTrace(int index) => deleteTraces([index]);

  /// Remove traces from a plot by specifying the indices of the traces to be
  /// removed.
  void deleteTraces(List<int> indices) {
    _Plotly.callMethod('deleteTraces', [_container, new JsObject.jsify(indices)]);
  }

  /// Reposition a trace in the plot. This will change the ordering of the
  /// layering and the legend.
  void moveTrace(int currentIndex, int newIndex) =>
      moveTraces([currentIndex], [newIndex]);

  /// Reorder traces in the plot. This will change the ordering of the
  /// layering and the legend.
  void moveTraces(List<int> currentIndices, List<int> newIndices) {
    _Plotly.callMethod('moveTraces', [_container, new JsObject.jsify(currentIndices), new JsObject.jsify(newIndices)]);
  }

  /// Use redraw to trigger a complete recalculation and redraw of the graph.
  /// This is not the fastest way to change single attributes, but may be the
  /// simplest way. You can make any arbitrary change to the data and layout
  /// objects, including completely replacing them, then call redraw.
  void redraw() {
    _Plotly.callMethod('redraw', [_container]);
  }

  static getSchema() => context['Plotly']['PlotSchema'].callMethod("get");
}
