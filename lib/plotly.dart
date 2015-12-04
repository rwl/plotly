library plotly;

import 'dart:html';
import 'dart:js';
import 'dart:async';

/// Interactive scientific chart.
class Plot {
  JsObject _Plotly;
  Element _container;
  JsObject _proxy;

  StreamController _clickCtrl = new StreamController.broadcast();

  StreamController _beforeHoverCtrl = new StreamController.broadcast();
  StreamController _hoverCtrl = new StreamController.broadcast();
  StreamController _unhoverCtrl = new StreamController.broadcast();

  /// Create a new plot in an empty `<div>` element.
  ///
  /// A note on sizing: You can either supply height and width in layout, or
  /// give the `div` a height and width in CSS.
  Plot(this._container, List data, Map<String, dynamic> layout,
      {bool showLink: false,
      bool staticPlot,
      String linkText,
      bool displaylogo: false,
      bool displayModeBar,
      bool scrollZoom}) {
    _Plotly = context['Plotly'];
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
    _attachEventListeners();
  }

  _attachEventListeners() {
    _proxy = new JsObject.fromBrowserObject(_container);
    _proxy.callMethod('on', ['plotly_click', (event) => _clickCtrl.add(event)]);

    _proxy.callMethod(
        'on', ['plotly_beforehover', (event) => _beforeHoverCtrl.add(event)]);
    _proxy.callMethod('on', ['plotly_hover', (event) => _hoverCtrl.add(event)]);
    _proxy.callMethod(
        'on', ['plotly_unhover', (event) => _unhoverCtrl.add(event)]);
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

  Stream get onClick => _clickCtrl.stream;
  Stream get onBeforeHover => _beforeHoverCtrl.stream;
  Stream get onHover => _hoverCtrl.stream;
  Stream get onUnhover => _unhoverCtrl.stream;

  /// An efficient means of changing parameters in the data array. When
  /// restyling, you may choose to have the specified changes effect as
  /// many traces as desired. The update is given as a single [Map] and
  /// the traces that are effected are given as a list of traces indices.
  /// Note, leaving the trace indices unspecified assumes that you want
  /// to restyle *all* the traces.
  void restyle(Map aobj, [List<int> traces]) {
    var _aobj = new JsObject.jsify(aobj);
    var args = [_container, _aobj];
    if (traces != null) {
      args.add(traces);
    }
    _Plotly.callMethod('restyle', args);
  }

  /// An efficient means of updating just the layout of a plot.
  void relayout(Map aobj) {
    var _aobj = new JsObject.jsify(aobj);
    _Plotly.callMethod('relayout', [_container, _aobj]);
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
    var args = [_container, traces];
    if (newIndices != null) {
      args.add(newIndices);
    }
    _Plotly.callMethod('addTraces', args);
  }

  /// Remove a trace from a plot by specifying the index of the trace to be
  /// removed.
  void deleteTrace(int index) => deleteTraces([index]);

  /// Remove traces from a plot by specifying the indices of the traces to be
  /// removed.
  void deleteTraces(List<int> indices) {
    _Plotly.callMethod('deleteTraces', [_container, indices]);
  }

  /// Reposition a trace in the plot. This will change the ordering of the
  /// layering and the legend.
  void moveTrace(int currentIndex, int newIndex) =>
      moveTraces([currentIndex], [newIndex]);

  /// Reorder traces in the plot. This will change the ordering of the
  /// layering and the legend.
  void moveTraces(List<int> currentIndices, List<int> newIndices) {
    _Plotly.callMethod('moveTraces', [_container, currentIndices, newIndices]);
  }

  /// Use redraw to trigger a complete recalculation and redraw of the graph.
  /// This is not the fastest way to change single attributes, but may be the
  /// simplest way. You can make any arbitrary change to the data and layout
  /// objects, including completely replacing them, then call redraw.
  void redraw() {
    _Plotly.callMethod('redraw', [_container]);
  }
}
