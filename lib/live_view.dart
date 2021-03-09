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
    startPreview();
  }

  void startPreview() async {
    await _channel?.invokeMethod(Constants.CMD_START_PREVIEW);
  }

  void switchCamera() async {
    await _channel?.invokeMethod(Constants.CMD_SWITCH_CAMERA);
  }

  void startLive(String url) async {
    await _channel?.invokeMethod(Constants.CMD_START_LIVE, url);
  }

  void pauseLive() async {
    await _channel?.invokeMethod(Constants.CMD_PAUSE_LIVE);
  }

  void resumeLive() async {
    await _channel?.invokeMethod(Constants.CMD_RESUME_LIVE);
  }

  void closeLive() async {
    await _channel?.invokeMethod(Constants.CMD_CLOSE_LIVE);
  }
}

/// 直播控件
class LiveView extends StatelessWidget {
  final LiveViewController controller;
  final AliLiveConfig config;

  const LiveView({Key key, this.controller, this.config}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return AndroidView(
        viewType: Constants.LIVE_VIEW_TYPE_ID,
        creationParamsCodec: StandardMessageCodec(),
        onPlatformViewCreated: controller?.onViewCreate,
        creationParams: config,
      );
    }

    if (Platform.isIOS) {
      return UiKitView(
        viewType: Constants.LIVE_VIEW_TYPE_ID,
        creationParamsCodec: StandardMessageCodec(),
        onPlatformViewCreated: controller?.onViewCreate,
        creationParams: config,
      );
    }

    return Container(
      color: Colors.white,
      child: Center(child: Text("该插件暂不支持此平台")),
    );
  }
}
