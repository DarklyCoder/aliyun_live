class Constants {
  static const String PREFIX_NAME = "com.pulin.aliyun_live/";

  static const String METHOD_CHANNEL_NAME = PREFIX_NAME + "ali_live_";
  static const String EVENT_CHANNEL_NAME = PREFIX_NAME + "ali_live_event_";
  static const String LIVE_VIEW_TYPE_ID = PREFIX_NAME + "AliLiveView";

  static const String CMD_START_PREVIEW = "startPreview"; // 开始预览
  static const String CMD_SWITCH_CAMERA = "switchCamera"; // 切换相机
  static const String CMD_START_LIVE = "startLive"; // 开始推流
  static const String CMD_PAUSE_LIVE = "pauseLive"; // 暂停推流
  static const String CMD_RESUME_LIVE = "resumeLive"; // 恢复推流
  static const String CMD_CLOSE_LIVE = "closeLive"; // 结束推流
  static const String CMD_AGAIN_LIVE = "againLive"; // 重新推流

  static const String PLAYER_METHOD_CHANNEL_NAME = PREFIX_NAME + "ali_player_";
  static const String PLAYER_EVENT_CHANNEL_NAME = PREFIX_NAME + "ali_player_event_";
  static const String PLAYER_VIEW_TYPE_ID = PREFIX_NAME + "AliPlayerView";

  static const String CMD_START_PLAY = "startPlay"; // 开始拉流
  static const String CMD_PAUSE_PLAY = "pausePlay"; // 暂停拉流
  static const String CMD_RESUME_PLAY = "resumePlay"; // 恢复拉流
  static const String CMD_PLAY_AGAIN = "playAgain"; // 重新拉流
  static const String CMD_CLOSE_PLAY = "closePlay"; // 结束拉流
}
