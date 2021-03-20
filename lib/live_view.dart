import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';

import 'package:aliyun_live/ali_live_config.dart';
import 'package:aliyun_live/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 控制器
class LiveViewController {
  MethodChannel _channel;
  StreamSubscription<dynamic> _event;
  final LiveCallback onLiveCallback;

  LiveViewController({this.onLiveCallback});

  void onViewCreate(int viewId) {
    _channel = MethodChannel(Constants.METHOD_CHANNEL_NAME + viewId.toString());

    var eventName = Constants.EVENT_CHANNEL_NAME + viewId.toString();
    _event = EventChannel(eventName)
        .receiveBroadcastStream()
        .listen(_eventData, onError: _eventError, onDone: _eventDone);

    startPreview();
  }

  /// 出错回调
  void _eventError(error) {
    print("@@@@@eventError:$error");
  }

  /// 接收数据回调
  void _eventData(event) {
    print("@@@@@eventData:$event");
    var resp = convert.jsonDecode(event);

    if (null != onLiveCallback) {
      onLiveCallback(resp["type"], resp["info"]);
    }
  }

  /// 关闭并发送完成事件流，回调
  void _eventDone() {
    print("@@@@@eventDone");
  }

  Future startPreview() async {
    return _channel?.invokeMethod(Constants.CMD_START_PREVIEW);
  }

  Future switchCamera() async {
    return _channel?.invokeMethod(Constants.CMD_SWITCH_CAMERA);
  }

  Future startLive(AliLiveConfig config) async {
    return _channel?.invokeMethod(Constants.CMD_START_LIVE, config.toJson());
  }

  Future pauseLive() async {
    return _channel?.invokeMethod(Constants.CMD_PAUSE_LIVE);
  }

  Future resumeLive() async {
    return _channel?.invokeMethod(Constants.CMD_RESUME_LIVE);
  }

  Future closeLive() async {
    return _channel?.invokeMethod(Constants.CMD_CLOSE_LIVE);
  }

  Future againLive(AliLiveConfig config) async {
    return _channel?.invokeMethod(Constants.CMD_AGAIN_LIVE, config.toJson());
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
        creationParams: config?.toJson(),
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
