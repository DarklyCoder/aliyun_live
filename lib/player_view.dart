import 'dart:io';

import 'package:aliyun_live/ali_live_config.dart';
import 'package:aliyun_live/contsants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 播放控制器
class PlayerViewController {
  MethodChannel _channel;

  void onViewCreate(int viewId) {
    var name = Constants.PLAYER_METHOD_CHANNEL_NAME + viewId.toString();
    _channel = MethodChannel(name);
  }

  void startPlay(String url) async {
    await _channel?.invokeMethod(Constants.CMD_START_PLAY, url);
  }

  void stopPlay() async {
    await _channel?.invokeMethod(Constants.CMD_STOP_PLAY);
  }

  void playAgain() async {
    await _channel?.invokeMethod(Constants.CMD_PLAY_AGAIN);
  }

  void closePlay() async {
    await _channel?.invokeMethod(Constants.CMD_CLOSE_PLAY);
  }
}

/// 直播视频播放控件
class PlayerView extends StatelessWidget {
  final PlayerViewController controller;
  final AliLiveConfig config;

  const PlayerView({Key key, this.controller, this.config}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return AndroidView(
        viewType: Constants.PLAYER_VIEW_TYPE_ID,
        creationParamsCodec: StandardMessageCodec(),
        onPlatformViewCreated: controller?.onViewCreate,
        creationParams: config,
      );
    }

    if (Platform.isIOS) {
      return UiKitView(
        viewType: Constants.PLAYER_VIEW_TYPE_ID,
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
