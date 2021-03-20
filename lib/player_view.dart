import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';

import 'package:aliyun_live/ali_live_config.dart';
import 'package:aliyun_live/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 播放控制器
class PlayerViewController {
  MethodChannel _channel;
  StreamSubscription<dynamic> _event;
  final LiveCallback onLiveCallback;
  LiveCallback _callback;

  PlayerViewController({this.onLiveCallback});

  void onViewCreate(int viewId, LiveCallback callback) {
    _callback = callback;
    var name = Constants.PLAYER_METHOD_CHANNEL_NAME + viewId.toString();
    _channel = MethodChannel(name);

    var eventName = Constants.PLAYER_EVENT_CHANNEL_NAME + viewId.toString();
    _event = EventChannel(eventName)
        .receiveBroadcastStream()
        .listen(_eventData, onError: _eventError, onDone: _eventDone);
  }

  /// 出错回调
  void _eventError(error) {
    print("@@@@@eventError:$error");
  }

  /// 接收数据回调
  void _eventData(event) {
    /// ERROR_GENERAL_EIO io中断
    /// ERROR_UNKNOWN 没网

    print("@@@@@eventData:$event");
    var resp = convert.jsonDecode(event);

    if (null != onLiveCallback) {
      onLiveCallback(resp["type"], resp["info"]);
    }
    if (null != _callback) {
      _callback(resp["type"], resp["info"]);
    }
  }

  /// 关闭并发送完成事件流，回调
  void _eventDone() {
    print("@@@@@eventDone");
  }

  Future startPlay(AliLiveConfig config) async {
    return _channel?.invokeMethod(Constants.CMD_START_PLAY, config.toJson());
  }

  Future pausePlay() async {
    return _channel?.invokeMethod(Constants.CMD_PAUSE_PLAY);
  }

  Future resumePlay() async {
    return _channel?.invokeMethod(Constants.CMD_RESUME_PLAY);
  }

  Future playAgain(AliLiveConfig config) async {
    return _channel?.invokeMethod(Constants.CMD_PLAY_AGAIN, config.toJson());
  }

  Future closePlay() async {
    return _channel?.invokeMethod(Constants.CMD_CLOSE_PLAY);
  }
}

/// 直播视频播放控件
class PlayerView extends StatelessWidget {
  final PlayerViewController controller;
  final AliLiveConfig config;
  final LiveCallback onLiveCallback;

  const PlayerView({Key key, this.controller, this.config, this.onLiveCallback}) : super(key: key);

  void _onViewCreate(int viewId) {
    controller?.onViewCreate(viewId, onLiveCallback);
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return AndroidView(
        viewType: Constants.PLAYER_VIEW_TYPE_ID,
        creationParamsCodec: StandardMessageCodec(),
        onPlatformViewCreated: _onViewCreate,
        creationParams: config?.toJson(),
      );
    }

    if (Platform.isIOS) {
      return UiKitView(
        viewType: Constants.PLAYER_VIEW_TYPE_ID,
        creationParamsCodec: StandardMessageCodec(),
        onPlatformViewCreated: _onViewCreate,
        creationParams: config?.toJson(),
      );
    }

    return Container(
      color: Colors.white,
      child: Center(child: Text("该插件暂不支持此平台")),
    );
  }
}
