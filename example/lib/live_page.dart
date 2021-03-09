import 'package:aliyun_live/aliyun_live.dart';
import 'package:flutter/material.dart';

/// 直播界面
class LivePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LivePageState();
  }
}

class _LivePageState extends State<LivePage> {
  LiveViewController controller;

  /// 推流地址
  String pushUrl = "rtmp://192.168.3.198:1935/rtmplive/room";

  @override
  void initState() {
    super.initState();

    controller = LiveViewController();
  }

  @override
  void dispose() {
    controller?.closeLive();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("推流演示")),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Stack(
      children: [
        LiveView(controller: controller),
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            MaterialButton(
              onPressed: () => controller.startPreview(),
              child: Text("开始预览"),
            ),
            MaterialButton(
              onPressed: () => controller.switchCamera(),
              child: Text("切换相机"),
            ),
            MaterialButton(
              onPressed: () => controller.startLive(pushUrl),
              child: Text("开始直播"),
            ),
            MaterialButton(
              onPressed: () => controller.pauseLive(),
              child: Text("暂停推流"),
            ),
            MaterialButton(
              onPressed: () => controller.resumeLive(),
              child: Text("恢复推流"),
            ),
            MaterialButton(
              onPressed: () => controller.closeLive(),
              child: Text("结束直播"),
            ),
          ],
        ),
      ),
    );
  }
}
