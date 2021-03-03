import 'dart:io';

import 'package:aliyun_live/ali_live_config.dart';
import 'package:aliyun_live/contsants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 控制器
class PlayerViewController {
  MethodChannel _channel;

  void onViewCreate(int viewId) {
    var name = Constants.PLAYER_METHOD_CHANNEL_NAME + viewId.toString();
    _channel = MethodChannel(name);
  }

  void startPlay(String url) async {
    await _channel.invokeMethod('startPlay', url);
  }

  void stopPlay() async {
    await _channel.invokeMethod('stopPlay');
  }

  void playAgain() async {
    await _channel.invokeMethod('playAgain');
  }

  void closePlay() async {
    await _channel.invokeMethod('closePlay');
  }

  void release() async {}
}

/// 直播视频播放控件
class PlayerView extends StatefulWidget {
  final PlayerViewController controller;
  final AliLiveConfig config;

  const PlayerView({Key key, this.controller, this.config}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PlayerViewState();
  }
}

class _PlayerViewState extends State<PlayerView> {
  @override
  Widget build(BuildContext context) {
    var playerView = Platform.isAndroid
        ? AndroidView(
            viewType: Constants.PLAYER_VIEW_TYPE_ID,
            creationParamsCodec: StandardMessageCodec(),
            onPlatformViewCreated: widget.controller?.onViewCreate,
            creationParams: widget.config,
          )
        : Platform.isIOS
            ? UiKitView(
                viewType: Constants.PLAYER_VIEW_TYPE_ID,
                creationParamsCodec: StandardMessageCodec(),
                onPlatformViewCreated: widget.controller?.onViewCreate,
                creationParams: widget.config,
              )
            : Container(
                color: Colors.white,
              );

    return playerView;
  }
}
