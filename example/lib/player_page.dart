import 'package:aliyun_live/aliyun_live.dart';
import 'package:flutter/material.dart';

/// 播放界面
class PlayerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PlayerPageState();
  }
}

class _PlayerPageState extends State<PlayerPage> {
  PlayerViewController controller;
  AliLiveConfig liveConfig;
  String msg;

  @override
  void initState() {
    super.initState();

    controller = PlayerViewController(onLiveCallback: (type, info) {
      setState(() {
        msg = type + " - " + info;
      });
    });
    liveConfig = AliLiveConfig();
    // liveConfig.playStreamUrl = "rtmp://192.168.3.198:1935/rtmplive/room";
    liveConfig.playStreamUrl = "rtmp://58.200.131.2:1935/livetv/cctv1";
  }

  @override
  void dispose() async {
    super.dispose();
    await controller?.closePlay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("拉流演示")),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Stack(
      children: [
        PlayerView(controller: controller, config: liveConfig),
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          child: _buildOptions(),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 40,
          child: Container(
            color: Colors.white,
            child: Text(msg ?? ""),
          ),
        ),
      ],
    );
  }

  Widget _buildOptions() {
    return Container(
      color: Color(0xFFFFFFFF),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            MaterialButton(
              onPressed: () async => await controller.startPlay(liveConfig),
              child: Text("开始拉流"),
            ),
            MaterialButton(
              onPressed: () async => await controller.pausePlay(),
              child: Text("暂停拉流"),
            ),
            MaterialButton(
              onPressed: () async => await controller.resumePlay(),
              child: Text("恢复拉流"),
            ),
            MaterialButton(
              onPressed: () async => await controller.playAgain(liveConfig),
              child: Text("重新拉流"),
            ),
            MaterialButton(
              onPressed: () async => await controller.closePlay(),
              child: Text("停止拉流"),
            ),
          ],
        ),
      ),
    );
  }
}
