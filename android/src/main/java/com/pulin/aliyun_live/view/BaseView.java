package com.pulin.aliyun_live.view;

import android.content.Context;

import com.pulin.aliyun_live.ALog;
import com.pulin.aliyun_live.model.Channel;
import com.pulin.aliyun_live.model.EventInfo;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

public abstract class BaseView implements PlatformView, MethodChannel.MethodCallHandler {
    private final Channel channel;
    protected final Context context;

    private EventChannel.EventSink eventSink;

    BaseView(BinaryMessenger messenger, Context context, int viewId, Object args) {
        this.context = context.getApplicationContext();
        this.channel = new Channel();
        initChannel(messenger, viewId);
        createView(args);
    }

    private void initChannel(BinaryMessenger messenger, int viewId) {
        channel.methodChannel = new MethodChannel(messenger, createMethodChannelName() + viewId);
        channel.eventChannel = new EventChannel(messenger, createEventChannelName() + viewId);
        channel.eventChannel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink events) {
                eventSink = events;
            }

            @Override
            public void onCancel(Object arguments) {
                eventSink = null;
            }
        });
        channel.methodChannel.setMethodCallHandler(this);
    }

    abstract String createMethodChannelName();

    abstract String createEventChannelName();

    abstract void createView(Object args);

    @Override
    public void dispose() {
        ALog.d(getClass().getSimpleName() + " dispose!");
//        channel.destroy();
    }

    /**
     * 回传到flutter
     */
    protected void callback(EventInfo info) {
        if (null != eventSink) {
            try {
                eventSink.success(info.toString());

            } catch (Exception e) {
                ALog.d("消息回调异常");
                ALog.e(e);
            }
        }
    }
}
