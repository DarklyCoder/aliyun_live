import 'dart:io';

import 'package:aliyun_live/ali_live_config.dart';
import 'package:aliyun_live/contsants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 控制器
class LiveViewController {
  MethodChannel _channel;

  void onViewCreate(int viewId) {
    _channel = MethodChannel(Constants.METHOD_CHANNEL_NAME + viewId.toString());
  }

  void startPreview() async {
    await _channel.invokeMethod('startPreview');
  }

  void startLive(String url) async {
    await _channel.invokeMethod('startLive', url);
  }

  void closeLive() async {
    await _channel.invokeMethod('closeLive');
  }
}

/// 直播控件
class LiveView extends StatefulWidget {
  final LiveViewController controller;
  final AliLiveConfig config;

  const LiveView({Key key, this.controller, this.config}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LiveViewState();
  }
}

class _LiveViewState extends State<LiveView> {
  @override
  Widget build(BuildContext context) {
    var playerView = Platform.isAndroid
        ? AndroidView(
            viewType: Constants.LIVE_VIEW_TYPE_ID,
            creationParamsCodec: StandardMessageCodec(),
            onPlatformViewCreated: widget.controller?.onViewCreate,
            creationParams: widget.config,
          )
        : Platform.isIOS
            ? UiKitView(
                viewType: Constants.LIVE_VIEW_TYPE_ID,
                creationParamsCodec: StandardMessageCodec(),
                onPlatformViewCreated: widget.controller?.onViewCreate,
                creationParams: widget.config,
              )
            : Container();

    return playerView;
  }
}
