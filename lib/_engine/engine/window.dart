// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// @dart = 2.6
part of dart._engine;

/// When set to true, all platform messages will be printed to the console.
const bool _debugPrintPlatformMessages = false;

/// The Web implementation of [ui.Window].
class EngineWindow extends ui.Window {
  EngineWindow() {
    _addBrightnessMediaQueryListener();
  }

  @override
  double get devicePixelRatio => _debugDevicePixelRatio != null
      ? _debugDevicePixelRatio
      : browserDevicePixelRatio;

  /// Returns device pixel ratio returned by browser.
  static double get browserDevicePixelRatio {
    double ratio = html.window.devicePixelRatio;
    // Guard against WebOS returning 0.
    return (ratio == null || ratio == 0.0) ? 1.0 : ratio;
  }

  /// Overrides the default device pixel ratio.
  ///
  /// This is useful in tests to emulate screens of different dimensions.
  void debugOverrideDevicePixelRatio(double value) {
    _debugDevicePixelRatio = value;
  }

  double _debugDevicePixelRatio;

  @override
  ui.Size get physicalSize {
    if (_physicalSize == null) {
      _computePhysicalSize();
    }
    assert(_physicalSize != null);
    return _physicalSize;
  }

  /// Computes the physical size of the screen from [html.window].
  ///
  /// This function is expensive. It triggers browser layout if there are
  /// pending DOM writes.
  void _computePhysicalSize() {
    bool override = false;

    assert(() {
      if (webOnlyDebugPhysicalSizeOverride != null) {
        _physicalSize = webOnlyDebugPhysicalSizeOverride;
        override = true;
      }
      return true;
    }());

    if (!override) {
      double windowInnerWidth;
      double windowInnerHeight;
      if (html.window.visualViewport != null) {
        windowInnerWidth = html.window.visualViewport.width * devicePixelRatio;
        windowInnerHeight =
            html.window.visualViewport.height * devicePixelRatio;
      } else {
        windowInnerWidth = html.window.innerWidth * devicePixelRatio;
        windowInnerHeight = html.window.innerHeight * devicePixelRatio;
      }
      _physicalSize = ui.Size(
        windowInnerWidth,
        windowInnerHeight,
      );
    }
  }

  /// Lazily populated and cleared at the end of the frame.
  ui.Size _physicalSize;

  /// Overrides the value of [physicalSize] in tests.
  ui.Size webOnlyDebugPhysicalSizeOverride;

  @override
  double get physicalDepth => double.maxFinite;

  /// Handles the browser history integration to allow users to use the back
  /// button, etc.
  final BrowserHistory _browserHistory = BrowserHistory();

  /// Simulates clicking the browser's back button.
  Future<void> webOnlyBack() => _browserHistory.back();

  /// Lazily initialized when the `defaultRouteName` getter is invoked.
  ///
  /// The reason for the lazy initialization is to give enough time for the app to set [locationStrategy]
  /// in `lib/src/ui/initialization.dart`.
  String _defaultRouteName;

  @override
  String get defaultRouteName => _defaultRouteName ??= _browserHistory.currentPath;

  /// Change the strategy to use for handling browser history location.
  /// Setting this member will automatically update [_browserHistory].
  ///
  /// By setting this to null, the browser history will be disabled.
  set locationStrategy(LocationStrategy strategy) {
    _browserHistory.locationStrategy = strategy;
  }

  @override
  ui.VoidCallback get onTextScaleFactorChanged => _onTextScaleFactorChanged;
  ui.VoidCallback _onTextScaleFactorChanged;
  Zone _onTextScaleFactorChangedZone;
  @override
  set onTextScaleFactorChanged(ui.VoidCallback callback) {
    _onTextScaleFactorChanged = callback;
    _onTextScaleFactorChangedZone = Zone.current;
  }

  /// Engine code should use this method instead of the callback directly.
  /// Otherwise zones won't work properly.
  void invokeOnTextScaleFactorChanged() {
    _invoke(_onTextScaleFactorChanged, _onTextScaleFactorChangedZone);
  }

  @override
  ui.VoidCallback get onPlatformBrightnessChanged => _onPlatformBrightnessChanged;
  ui.VoidCallback _onPlatformBrightnessChanged;
  Zone _onPlatformBrightnessChangedZone;
  @override
  set onPlatformBrightnessChanged(ui.VoidCallback callback) {
    _onPlatformBrightnessChanged = callback;
    _onPlatformBrightnessChangedZone = Zone.current;
  }

  /// Engine code should use this method instead of the callback directly.
  /// Otherwise zones won't work properly.
  void invokeOnPlatformBrightnessChanged() {
    _invoke(_onPlatformBrightnessChanged, _onPlatformBrightnessChangedZone);
  }

  @override
  ui.VoidCallback get onMetricsChanged => _onMetricsChanged;
  ui.VoidCallback _onMetricsChanged;
  Zone _onMetricsChangedZone;
  @override
  set onMetricsChanged(ui.VoidCallback callback) {
    _onMetricsChanged = callback;
    _onMetricsChangedZone = Zone.current;
  }

  /// Engine code should use this method instead of the callback directly.
  /// Otherwise zones won't work properly.
  void invokeOnMetricsChanged() {
    _invoke(_onMetricsChanged, _onMetricsChangedZone);
  }

  @override
  ui.VoidCallback get onLocaleChanged => _onLocaleChanged;
  ui.VoidCallback _onLocaleChanged;
  Zone _onLocaleChangedZone;
  @override
  set onLocaleChanged(ui.VoidCallback callback) {
    _onLocaleChanged = callback;
    _onLocaleChangedZone = Zone.current;
  }

  /// Engine code should use this method instead of the callback directly.
  /// Otherwise zones won't work properly.
  void invokeOnLocaleChanged() {
    _invoke(_onLocaleChanged, _onLocaleChangedZone);
  }

  @override
  ui.FrameCallback get onBeginFrame => _onBeginFrame;
  ui.FrameCallback _onBeginFrame;
  Zone _onBeginFrameZone;
  @override
  set onBeginFrame(ui.FrameCallback callback) {
    _onBeginFrame = callback;
    _onBeginFrameZone = Zone.current;
  }

  /// Engine code should use this method instead of the callback directly.
  /// Otherwise zones won't work properly.
  void invokeOnBeginFrame(Duration duration) {
    _invoke1<Duration>(_onBeginFrame, _onBeginFrameZone, duration);
  }

  @override
  ui.TimingsCallback get onReportTimings => _onReportTimings;
  ui.TimingsCallback _onReportTimings;
  Zone _onReportTimingsZone;
  @override
  set onReportTimings(ui.TimingsCallback callback) {
    _onReportTimings = callback;
    _onReportTimingsZone = Zone.current;
  }

  /// Engine code should use this method instead of the callback directly.
  /// Otherwise zones won't work properly.
  void invokeOnReportTimings(List<ui.FrameTiming> timings) {
    _invoke1<List<ui.FrameTiming>>(_onReportTimings, _onReportTimingsZone, timings);
  }

  @override
  ui.VoidCallback get onDrawFrame => _onDrawFrame;
  ui.VoidCallback _onDrawFrame;
  Zone _onDrawFrameZone;
  @override
  set onDrawFrame(ui.VoidCallback callback) {
    _onDrawFrame = callback;
    _onDrawFrameZone = Zone.current;
  }

  /// Engine code should use this method instead of the callback directly.
  /// Otherwise zones won't work properly.
  void invokeOnDrawFrame() {
    _invoke(_onDrawFrame, _onDrawFrameZone);
  }

  @override
  ui.PointerDataPacketCallback get onPointerDataPacket => _onPointerDataPacket;
  ui.PointerDataPacketCallback _onPointerDataPacket;
  Zone _onPointerDataPacketZone;
  @override
  set onPointerDataPacket(ui.PointerDataPacketCallback callback) {
    _onPointerDataPacket = callback;
    _onPointerDataPacketZone = Zone.current;
  }

  /// Engine code should use this method instead of the callback directly.
  /// Otherwise zones won't work properly.
  void invokeOnPointerDataPacket(ui.PointerDataPacket packet) {
    _invoke1<ui.PointerDataPacket>(_onPointerDataPacket, _onPointerDataPacketZone, packet);
  }

  @override
  ui.VoidCallback get onSemanticsEnabledChanged => _onSemanticsEnabledChanged;
  ui.VoidCallback _onSemanticsEnabledChanged;
  Zone _onSemanticsEnabledChangedZone;
  @override
  set onSemanticsEnabledChanged(ui.VoidCallback callback) {
    _onSemanticsEnabledChanged = callback;
    _onSemanticsEnabledChangedZone = Zone.current;
  }

  /// Engine code should use this method instead of the callback directly.
  /// Otherwise zones won't work properly.
  void invokeOnSemanticsEnabledChanged() {
    _invoke(_onSemanticsEnabledChanged, _onSemanticsEnabledChangedZone);
  }

  @override
  ui.SemanticsActionCallback get onSemanticsAction => _onSemanticsAction;
  ui.SemanticsActionCallback _onSemanticsAction;
  Zone _onSemanticsActionZone;
  @override
  set onSemanticsAction(ui.SemanticsActionCallback callback) {
    _onSemanticsAction = callback;
    _onSemanticsActionZone = Zone.current;
  }

  /// Engine code should use this method instead of the callback directly.
  /// Otherwise zones won't work properly.
  void invokeOnSemanticsAction(int id, ui.SemanticsAction action, ByteData args) {
    _invoke3<int, ui.SemanticsAction, ByteData>(_onSemanticsAction,
        _onSemanticsActionZone, id, action, args);
  }

  @override
  ui.VoidCallback get onAccessibilityFeaturesChanged => _onAccessibilityFeaturesChanged;
  ui.VoidCallback _onAccessibilityFeaturesChanged;
  Zone _onAccessibilityFeaturesChangedZone;
  @override
  set onAccessibilityFeaturesChanged(ui.VoidCallback callback) {
    _onAccessibilityFeaturesChanged = callback;
    _onAccessibilityFeaturesChangedZone = Zone.current;
  }

  /// Engine code should use this method instead of the callback directly.
  /// Otherwise zones won't work properly.
  void invokeOnAccessibilityFeaturesChanged() {
    _invoke(_onAccessibilityFeaturesChanged, _onAccessibilityFeaturesChangedZone);
  }

  @override
  ui.PlatformMessageCallback get onPlatformMessage => _onPlatformMessage;
  ui.PlatformMessageCallback _onPlatformMessage;
  Zone _onPlatformMessageZone;
  @override
  set onPlatformMessage(ui.PlatformMessageCallback callback) {
    _onPlatformMessage = callback;
    _onPlatformMessageZone = Zone.current;
  }

  /// Engine code should use this method instead of the callback directly.
  /// Otherwise zones won't work properly.
  void invokeOnPlatformMessage(String name, ByteData data, ui.PlatformMessageResponseCallback callback) {
    _invoke3<String, ByteData, ui.PlatformMessageResponseCallback>(
      _onPlatformMessage,
      _onPlatformMessageZone,
      name,
      data,
      callback,
    );
  }

  @override
  void sendPlatformMessage(
    String name,
    ByteData data,
    ui.PlatformMessageResponseCallback callback,
  ) {
    _sendPlatformMessage(name, data, _zonedPlatformMessageResponseCallback(callback));
  }

  /// Wraps the given [callback] in another callback that ensures that the
  /// original callback is called in the zone it was registered in.
  static ui.PlatformMessageResponseCallback _zonedPlatformMessageResponseCallback(ui.PlatformMessageResponseCallback callback) {
    if (callback == null)
      return null;

    // Store the zone in which the callback is being registered.
    final Zone registrationZone = Zone.current;

    return (ByteData data) {
      registrationZone.runUnaryGuarded(callback, data);
    };
  }

  void _sendPlatformMessage(
    String name,
    ByteData data,
    ui.PlatformMessageResponseCallback callback,
  ) {
    // In widget tests we want to bypass processing of platform messages.
    if (assertionsEnabled && ui.debugEmulateFlutterTesterEnvironment) {
      return;
    }

    if (_debugPrintPlatformMessages) {
      print('Sent platform message on channel: "$name"');
    }

    if (assertionsEnabled && name == 'flutter/debug-echo') {
      // Echoes back the data unchanged. Used for testing purpopses.
      _replyToPlatformMessage(callback, data);
      return;
    }

    switch (name) {
      case 'flutter/assets':
        assert(ui.webOnlyAssetManager != null);
        final String url = utf8.decode(data.buffer.asUint8List());
        ui.webOnlyAssetManager.load(url).then((ByteData assetData) {
          _replyToPlatformMessage(callback, assetData);
        }, onError: (dynamic error) {
          html.window.console
              .warn('Error while trying to load an asset: $error');
          _replyToPlatformMessage(callback, null);
        });
        return;

      case 'flutter/platform':
        const MethodCodec codec = JSONMethodCodec();
        final MethodCall decoded = codec.decodeMethodCall(data);
        switch (decoded.method) {
          case 'SystemNavigator.pop':
            _browserHistory.exit().then((_) {
              _replyToPlatformMessage(
                  callback, codec.encodeSuccessEnvelope(true));
            });
            return;
          case 'HapticFeedback.vibrate':
            final String type = decoded.arguments;
            domRenderer.vibrate(_getHapticFeedbackDuration(type));
            _replyToPlatformMessage(callback, codec.encodeSuccessEnvelope(true));
            return;
          case 'SystemChrome.setApplicationSwitcherDescription':
            final Map<String, dynamic> arguments = decoded.arguments;
            domRenderer.setTitle(arguments['label']);
            domRenderer.setThemeColor(ui.Color(arguments['primaryColor']));
            _replyToPlatformMessage(callback, codec.encodeSuccessEnvelope(true));
            return;
          case 'SystemSound.play':
            // There are no default system sounds on web.
            _replyToPlatformMessage(callback, codec.encodeSuccessEnvelope(true));
            return;
          case 'Clipboard.setData':
            ClipboardMessageHandler().setDataMethodCall(decoded, callback);
            return;
          case 'Clipboard.getData':
            ClipboardMessageHandler().getDataMethodCall(callback);
            return;
        }
        break;

      case 'flutter/textinput':
        textEditing.channel.handleTextInput(data, callback);
        return;

      case 'flutter/web_test_e2e':
        const MethodCodec codec = JSONMethodCodec();
        _replyToPlatformMessage(callback, codec.encodeSuccessEnvelope(
          _handleWebTestEnd2EndMessage(codec, data)
        ));
        return;

      case 'flutter/platform_views':
        if (experimentalUseSkia) {
          rasterizer.viewEmbedder.handlePlatformViewCall(data, callback);
        } else {
          handlePlatformViewCall(data, callback);
        }
        return;

      case 'flutter/accessibility':
        // In widget tests we want to bypass processing of platform messages.
        final StandardMessageCodec codec = StandardMessageCodec();
        accessibilityAnnouncements.handleMessage(codec, data);
        _replyToPlatformMessage(callback, codec.encodeMessage(true));
        return;

      case 'flutter/navigation':
        const MethodCodec codec = JSONMethodCodec();
        final MethodCall decoded = codec.decodeMethodCall(data);
        final Map<String, dynamic> message = decoded.arguments;
        switch (decoded.method) {
          case 'routeUpdated':
          case 'routePushed':
          case 'routeReplaced':
            _browserHistory.setRouteName(message['routeName']);
            _replyToPlatformMessage(callback, codec.encodeSuccessEnvelope(true));
            break;
          case 'routePopped':
            _browserHistory.setRouteName(message['previousRouteName']);
            _replyToPlatformMessage(callback, codec.encodeSuccessEnvelope(true));
            break;
        }
        // As soon as Flutter starts taking control of the app navigation, we
        // should reset [_defaultRouteName] to "/" so it doesn't have any
        // further effect after this point.
        _defaultRouteName = '/';
        return;
    }

    if (pluginMessageCallHandler != null) {
      pluginMessageCallHandler(name, data, callback);
      return;
    }

    // TODO(flutter_web): Some Flutter widgets send platform messages that we
    // don't handle on web. So for now, let's just ignore them. In the future,
    // we should consider uncommenting the following "callback(null)" line.

    // Passing [null] to [callback] indicates that the platform message isn't
    // implemented. Look at [MethodChannel.invokeMethod] to see how [null] is
    // handled.
    // callback(null);
  }

  int _getHapticFeedbackDuration(String type) {
    switch (type) {
      case 'HapticFeedbackType.lightImpact':
        return DomRenderer.vibrateLightImpact;
      case 'HapticFeedbackType.mediumImpact':
        return DomRenderer.vibrateMediumImpact;
      case 'HapticFeedbackType.heavyImpact':
        return DomRenderer.vibrateHeavyImpact;
      case 'HapticFeedbackType.selectionClick':
        return DomRenderer.vibrateSelectionClick;
      default:
        return DomRenderer.vibrateLongPress;
    }
  }

  /// In Flutter, platform messages are exchanged between threads so the
  /// messages and responses have to be exchanged asynchronously. We simulate
  /// that by adding a zero-length delay to the reply.
  void _replyToPlatformMessage(
    ui.PlatformMessageResponseCallback callback,
    ByteData data,
  ) {
    Future<void>.delayed(Duration.zero).then((_) {
      if (callback != null) {
        callback(data);
      }
    });
  }

  @override
  ui.Brightness get platformBrightness => _platformBrightness;
  ui.Brightness _platformBrightness = ui.Brightness.light;

  /// Updates [_platformBrightness] and invokes [onPlatformBrightnessChanged]
  /// callback if [_platformBrightness] changed.
  void _updatePlatformBrightness(ui.Brightness newPlatformBrightness) {
    ui.Brightness previousPlatformBrightness = _platformBrightness;
    _platformBrightness = newPlatformBrightness;

    if (previousPlatformBrightness != _platformBrightness &&
        onPlatformBrightnessChanged != null) {
      invokeOnPlatformBrightnessChanged();
    }
  }

  /// Reference to css media query that indicates the user theme preference on the web.
  final html.MediaQueryList _brightnessMediaQuery =
      html.window.matchMedia('(prefers-color-scheme: dark)');

  /// A callback that is invoked whenever [_brightnessMediaQuery] changes value.
  ///
  /// Updates the [_platformBrightness] with the new user preference.
  html.EventListener _brightnessMediaQueryListener;

  /// Set the callback function for listening changes in [_brightnessMediaQuery] value.
  void _addBrightnessMediaQueryListener() {
    _updatePlatformBrightness(_brightnessMediaQuery.matches
        ? ui.Brightness.dark
        : ui.Brightness.light);

    _brightnessMediaQueryListener = (html.Event event) {
      final html.MediaQueryListEvent mqEvent = event;
      _updatePlatformBrightness(
          mqEvent.matches ? ui.Brightness.dark : ui.Brightness.light);
    };
    _brightnessMediaQuery.addListener(_brightnessMediaQueryListener);
    registerHotRestartListener(() {
      _removeBrightnessMediaQueryListener();
    });
  }

  /// Remove the callback function for listening changes in [_brightnessMediaQuery] value.
  void _removeBrightnessMediaQueryListener() {
    _brightnessMediaQuery.removeListener(_brightnessMediaQueryListener);
    _brightnessMediaQueryListener = null;
  }

  @override
  void render(ui.Scene scene) {
    if (experimentalUseSkia) {
      final LayerScene layerScene = scene;
      rasterizer.draw(layerScene.layerTree);
    } else {
      final SurfaceScene surfaceScene = scene;
      domRenderer.renderScene(surfaceScene.webOnlyRootElement);
    }
  }

  
  Rasterizer rasterizer = experimentalUseSkia ? Rasterizer(Surface()) : null;
}

bool _handleWebTestEnd2EndMessage(MethodCodec codec, ByteData data) {
  final MethodCall decoded = codec.decodeMethodCall(data);
  double ratio = double.parse(decoded.arguments);
  switch(decoded.method) {
    case 'setDevicePixelRatio':
      window.debugOverrideDevicePixelRatio(ratio);
      window.onMetricsChanged();
      return true;
  }
  return false;
}

/// Invokes [callback] inside the given [zone].
void _invoke(void callback(), Zone zone) {
  if (callback == null)
    return;

  assert(zone != null);

  if (identical(zone, Zone.current)) {
    callback();
  } else {
    zone.runGuarded(callback);
  }
}

/// Invokes [callback] inside the given [zone] passing it [arg].
void _invoke1<A>(void callback(A a), Zone zone, A arg) {
  if (callback == null)
    return;

  assert(zone != null);

  if (identical(zone, Zone.current)) {
    callback(arg);
  } else {
    zone.runUnaryGuarded<A>(callback, arg);
  }
}

/// Invokes [callback] inside the given [zone] passing it [arg1], [arg2], and [arg3].
void _invoke3<A1, A2, A3>(void callback(A1 a1, A2 a2, A3 a3), Zone zone, A1 arg1, A2 arg2, A3 arg3) {
  if (callback == null)
    return;

  assert(zone != null);

  if (identical(zone, Zone.current)) {
    callback(arg1, arg2, arg3);
  } else {
    zone.runGuarded(() {
      callback(arg1, arg2, arg3);
    });
  }
}

/// The window singleton.
///
/// `dart:ui` window delegates to this value. However, this value has a wider
/// API surface, providing Web-specific functionality that the standard
/// `dart:ui` version does not.
final EngineWindow window = EngineWindow();
