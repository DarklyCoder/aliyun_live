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
  String _url = "rtmp://58.200.131.2:1935/livetv/cctv1";

  // String _url = "rtmp://192.168.3.198:1935/rtmplive/room";

  @override
  void initState() {
    super.initState();

    controller = PlayerViewController();
  }

  @override
  void dispose() {
    controller?.closePlay();
    super.dispose();
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
        PlayerView(controller: controller),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _buildOptions(),
        ),
      ],
    );
  }

  Widget _buildOptions() {
    return Container(
      color: Color(0xFFFFFFFF),
      child: Row(
        children: [
          MaterialButton(
            onPressed: () => controller.startPlay(_url),
            child: Text("开始拉流"),
          ),
          MaterialButton(
            onPressed: () => controller.stopPlay(),
            child: Text("暂停拉流"),
          ),
          MaterialButton(
            onPressed: () => controller.playAgain(),
            child: Text("重新拉流"),
          ),
          MaterialButton(
            onPressed: () => controller.closePlay(),
            child: Text("停止拉流"),
          ),
        ],
      ),
    );
  }
}
