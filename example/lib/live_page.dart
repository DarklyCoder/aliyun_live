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
  AliLiveConfig liveConfig;
  String msg;

  @override
  void initState() {
    super.initState();

    controller = LiveViewController(onLiveCallback: (type, info) {
      setState(() {
        msg = type + " - " + info;
      });
    });
    liveConfig = AliLiveConfig();
    liveConfig.pushStreamUrl = "rtmp://192.168.3.198:1935/rtmplive/room";
  }

  @override
  void dispose() async {
    super.dispose();
    await controller?.closeLive();
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
        LiveView(controller: controller, config: liveConfig),
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
              onPressed: () async => await controller.startPreview(),
              child: Text("开始预览"),
            ),
            MaterialButton(
              onPressed: () async => await controller.switchCamera(),
              child: Text("切换相机"),
            ),
            MaterialButton(
              onPressed: () async => await controller.startLive(liveConfig),
              child: Text("开始直播"),
            ),
            MaterialButton(
              onPressed: () async => await controller.pauseLive(),
              child: Text("暂停推流"),
            ),
            MaterialButton(
              onPressed: () async => await controller.resumeLive(),
              child: Text("恢复推流"),
            ),
            MaterialButton(
              onPressed: () async => await controller.closeLive(),
              child: Text("结束直播"),
            ),
            MaterialButton(
              onPressed: () async => await controller.againLive(liveConfig),
              child: Text("重新推流"),
            ),
          ],
        ),
      ),
    );
  }
}
