package com.pulin.aliyun_live;

public final class Constants {
    private static final String PREFIX_NAME = "com.pulin.aliyun_live/";

    public static final String METHOD_CHANNEL_NAME = PREFIX_NAME + "ali_live_";
    public static final String EVENT_CHANNEL_NAME = PREFIX_NAME + "ali_live_event_";
    public static final String LIVE_VIEW_TYPE_ID = PREFIX_NAME + "AliLiveView";

    public static final String CMD_START_PREVIEW = "startPreview"; // 开始预览
    public static final String CMD_SWITCH_CAMERA = "switchCamera"; // 切换相机
    public static final String CMD_START_LIVE = "startLive"; // 开始推流
    public static final String CMD_PAUSE_LIVE = "pauseLive"; // 暂停推流
    public static final String CMD_RESUME_LIVE = "resumeLive"; // 恢复推流
    public static final String CMD_CLOSE_LIVE = "closeLive"; // 结束推流
    public static final String CMD_AGAIN_LIVE = "againLive"; // 重新推流

    public static final String PLAYER_METHOD_CHANNEL_NAME = PREFIX_NAME + "ali_player_";
    public static final String PLAYER_EVENT_CHANNEL_NAME = PREFIX_NAME + "ali_player_event_";
    public static final String PLAYER_VIEW_TYPE_ID = PREFIX_NAME + "AliPlayerView";

    public static final String CMD_START_PLAY = "startPlay"; // 开始拉流
    public static final String CMD_PAUSE_PLAY = "pausePlay"; // 暂停拉流
    public static final String CMD_RESUME_PLAY = "resumePlay"; // 恢复拉流
    public static final String CMD_PLAY_AGAIN = "playAgain"; // 重新拉流
    public static final String CMD_CLOSE_PLAY = "closePlay"; // 结束拉流
}
