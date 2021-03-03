import 'package:aliyun_live/ali_live_rtmp_config.dart';

/// 阿里云直播SDK配置RTMP和RTC推流初始化参数配置模块，创建直播引擎时需要将配置对象通过参数的形式传入，配置只能在推流开始前设置，推流开始后重新设置配置无效。
class AliLiveConfig {
  String accountId; // 连麦域名HTTPDNS解析账号ID（连麦场景下必须设置）。
  AliLiveRTMPConfig rtmpConfig; // RTMP推流参数属性。
  int cameraPosition; // 相机位置。
  bool audioOnly = false; //	纯音频连麦。
  bool autoFocus = false; // 是否支持自动对焦。
  int videoPushProfile; // 视频推流分辨率。
  int videoFPS = 20; //	视频帧率。
  // 是否开启高清预览。如果采集分辨率低于720P时，本地预览以720P的方式呈现，采集分辨率高于720P以实际分辨率预览。
  bool enableHighDefPreview = false;
  bool enableVideoEncoderHWAcceleration = true; //	视频硬编码。
  bool enableVideoDecoderHWAcceleration = true; //	视频硬解码。
  int videoGopSize; // 视频编码GOP大小，单位：s。
  // 可以设置推流一张图片，此时观众只能看到推的这张图片，常用于App切换至后台。设置后调用pausePush推送图片。
  dynamic pauseImage;
  int videoRenderMode; //	视频显示模式。
  int pushMirror; // 推流镜像。
  bool flash = false; // 开启闪光灯。
  num zoom = 1.0; // 画面缩放。
  String extra; // 辅助字段，用户可以传入直播成员唯一标示，用于SDK问题的日志排查。
}
