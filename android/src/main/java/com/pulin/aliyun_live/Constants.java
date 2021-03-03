package com.pulin.aliyun_live;

public final class Constants {
    private static final String PREFIX_NAME = "com.pulin.aliyun_live/";

    public static final String METHOD_CHANNEL_NAME = PREFIX_NAME + "ali_live_";
    public static final String EVENT_CHANNEL_NAME = PREFIX_NAME + "ali_live_event_";
    public static final String LIVE_VIEW_TYPE_ID = PREFIX_NAME + "AliLiveView";

    public static final String PLAYER_METHOD_CHANNEL_NAME = PREFIX_NAME + "ali_player_";
    public static final String PLAYER_EVENT_CHANNEL_NAME = PREFIX_NAME + "ali_player_event_";
    public static final String PLAYER_VIEW_TYPE_ID = PREFIX_NAME + "AliPlayerView";

    public static final String CMD_START_PLAY = "startPlay"; // 开始拉流
    public static final String CMD_STOP_PLAY = "stopPlay"; // 暂停拉流
    public static final String CMD_PLAY_AGAIN = "playAgain"; // 重新拉流
    public static final String CMD_CLOSE_PLAY = "closePlay"; // 结束拉流
}
