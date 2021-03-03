/// 阿里云直播SDK配置RTMP推流初始化参数配置模块，创建直播引擎时需要将配置对象通过参数的形式传入，配置只能在推流开始前设置，推流开始后重新配置无效。
class AliLiveRTMPConfig {
  bool enableAudioHWAcceleration = false; // 音频软编码。
  int videoInitBitrate = 1000; //	视频编码初始编码码率，单位：Kbps。
  int videoTargetBitrate = 1500; //	视频编码目标编码码率，单位：Kbps。
  int videoMinBitrate = 600; //	视频编码最小编码码率，单位：Kbps。
  int audioChannel; // 音频声道数。
  int audioSampleRate; // 音频采样率。
  int audioEncoderProfile; //	音频编码格式。
  int autoReconnectRetryCount = 5; //	推流自动重连次数。
  int autoReconnectRetryInterval = 1000; //	推流自动重连间隔，单位：ms。
}
