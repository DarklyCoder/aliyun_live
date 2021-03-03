package com.pulin.aliyun_live;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

public class Channel {

    public MethodChannel methodChannel;
    public EventChannel eventChannel;

    public void destroy() {
        if (null != methodChannel) {
            methodChannel.setMethodCallHandler(null);
            methodChannel = null;
        }

        if (null != eventChannel) {
            eventChannel.setStreamHandler(null);
            eventChannel = null;
        }
    }
}
