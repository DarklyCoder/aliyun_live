typedef LiveCallback = void Function(String type, String info);

/// 阿里云直播配置
class AliLiveConfig {
  String pushStreamUrl; // 推流地址
  String playStreamUrl; // 播流地址
  String cover; // 封面地址
  num resolutionType; // 分辨率类型，1:640*480，2:1280*720，3:1920*1080
  int frameType; // 帧率类型，1：30fps，2：60fps 3: 25fps
  int rateType; // 码率类型，1：1500kbps，2：2000kbps，3：3000kbps
  int codeType; // 编码类型，1：硬件，2：软件

  AliLiveConfig({
    this.pushStreamUrl,
    this.playStreamUrl,
    this.cover,
    this.resolutionType,
    this.frameType,
    this.rateType,
    this.codeType,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pushStreamUrl'] = this.pushStreamUrl;
    data['playStreamUrl'] = this.playStreamUrl;
    data['cover'] = this.cover;
    data['resolutionType'] = this.resolutionType;
    data['frameType'] = this.frameType;
    data['rateType'] = this.rateType;
    data['codeType'] = this.codeType;
    return data;
  }
}
