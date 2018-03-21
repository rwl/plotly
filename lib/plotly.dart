library plotly;

import 'dart:html';
import 'dart:js';
import 'dart:async';

/// Interactive scientific chart.
class Plot {
  final JsObject _Plotly;
  final Element _container;
  final JsObject _proxy;

  /// Creates a new plot in an empty `<div>` element.
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

  /// Creates a new plot in an empty `<div>` element with the given id.
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

  /// Creates a new plot in an empty `<div>` element with the given [selectors].
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

  /// Adds a new trace to an existing plot at any location in its data array.
  void addTrace(Map trace, [int newIndex]) {
    if (newIndex != null) {
      addTraces([trace], [newIndex]);
    } else {
      addTraces([trace]);
    }
  }

  /// Adds new traces to an existing plot at any location in its data array.
  void addTraces(List<Map> traces, [List<int> newIndices]) {
    var args = [_container, new JsObject.jsify(traces)];
    if (newIndices != null) {
      args.add(new JsObject.jsify(newIndices));
    }
    _Plotly.callMethod('addTraces', args);
  }

  /// Removes a trace from a plot by specifying the index of the trace to be
  /// removed.
  void deleteTrace(int index) => deleteTraces([index]);

  /// Removes traces from a plot by specifying the indices of the traces to be
  /// removed.
  void deleteTraces(List<int> indices) {
    _Plotly.callMethod('deleteTraces', [_container, new JsObject.jsify(indices)]);
  }

  /// Extend traces
  void extendTraces(Map aobj, List<int> indices) {
    var args = [_container, new JsObject.jsify(aobj), new JsObject.jsify(indices)];
    _Plotly.callMethod('extendTraces', args);
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

  /// Animates to frames.
  ///
  /// Parameter [frames] can be a single frame, array of
  /// frames, or group to which to animate. The intent is inferred by
  /// the type of the input. Valid inputs are:
  ///   * [String], e.g. 'groupname': animate all frames of a given `group` in
  ///     the order in which they are defined via [addFrames];
  ///   * [List<String>], e.g. ['frame1', frame2']: a list of frames by
  ///     name to which to animate in sequence;
  ///   * [Map], e.g {data: ...}: a frame definition to which to animate. The frame is not
  ///     and does not need to be added via [addFrames]. It may contain any of
  ///     the properties of a frame, including `data`, `layout`, and `traces`. The
  ///     frame is used as provided and does not use the `baseframe` property.
  ///   * [List<Map>], e.g. [{data: ...}, {data: ...}]: a list of frame objects,
  ///     each following the same rules as a single `object`.
  void animate(frames, [Map opts]) {
    final args = <dynamic>[_container];
    args.add((frames is Iterable || frames is Map) ? new JsObject.jsify(frames) : frames);
    if (opts != null) args.add(new JsObject.jsify(opts));
    _Plotly.callMethod('animate', args);
  }

  /// Registers new frames.
  ///
  /// [frameList] is a list of frame definitions, in which each object includes any of:
  /// * name: {[String]} name of frame to add;
  /// * data: {[List<Map>]} trace data;
  /// * layout: {[Map]} layout definition;
  /// * traces: {[List<int>]} trace indices;
  /// * baseframe {[String]} name of frame from which this frame gets defaults.
  ///
  /// [indices] is an list of integer indices matching the respective frames in [frameList]. If not
  /// provided, an index will be provided in serial order. If already used, the frame
  /// will be overwritten.
  void addFrames(List<Map> frameList, [List indices]) {
    var args = [_container, new JsObject.jsify(frameList)];
    if (indices != null) args.add(new JsObject.jsify(indices));
    _Plotly.callMethod('addFrames', args);
  }

  /// Deletes frames from plot by [indices].
  void deleteFrames(List<int> indices) {
    _Plotly.callMethod('deleteFrames', [_container, new JsObject.jsify(indices)]);
  }

  /// Use redraw to trigger a complete recalculation and redraw of the graph.
  /// This is not the fastest way to change single attributes, but may be the
  /// simplest way. You can make any arbitrary change to the data and layout
  /// objects, including completely replacing them, then call redraw.
  void redraw() {
    _Plotly.callMethod('redraw', [_container]);
  }

  void purge() {
    _Plotly.callMethod('purge', [_container]);
  }

  /// A method for updating both the data and layout objects at once.
  void update(Map dataUpdate, Map layoutUpdate) {
    _Plotly.callMethod('update', [_container, new JsObject.jsify(dataUpdate),
    new JsObject.jsify(layoutUpdate)]);
  }

  static getSchema() => context['Plotly']['PlotSchema'].callMethod("get");
}
