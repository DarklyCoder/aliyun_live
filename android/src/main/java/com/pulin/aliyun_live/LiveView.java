package com.pulin.aliyun_live;

import android.content.Context;
import android.text.TextUtils;
import android.view.View;

import androidx.annotation.NonNull;

import com.alivc.live.AliLiveConfig;
import com.alivc.live.AliLiveConstants;
import com.alivc.live.AliLiveEngine;
import com.alivc.live.AliLiveRTMPConfig;
import com.alivc.live.AliLiveRenderView;

import java.util.HashMap;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

import static com.alivc.live.AliLiveConstants.AliLiveRenderMirrorMode.AliLiveRenderMirrorModeOnlyFront;
import static com.alivc.live.AliLiveConstants.AliLiveRenderMode.AliLiveRenderModeAuto;

/**
 * 直播组件
 */
public class LiveView implements PlatformView, MethodChannel.MethodCallHandler {

    Channel channel;
    int viewId;
    private AliLiveEngine mAliLiveEngine;
    private AliLiveRenderView mAliLiveRenderView;
    private EventChannel.EventSink eventSink;

    LiveView(BinaryMessenger messenger, Context context, int viewId, HashMap<String, Object> args) {
        this.viewId = viewId;
        this.channel = new Channel();
        initChannel(messenger, viewId);
        createView(context, args);
    }

    private void initChannel(BinaryMessenger messenger, int viewId) {
        channel.methodChannel = new MethodChannel(messenger, Constants.METHOD_CHANNEL_NAME + viewId);
        channel.eventChannel = new EventChannel(messenger, Constants.EVENT_CHANNEL_NAME + viewId);
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

    private void createView(Context context, HashMap<String, Object> args) {
        // 创建RTMP相关配置对象
        AliLiveRTMPConfig rtmpConfig = new AliLiveRTMPConfig();
        // 初始化码率配置
        rtmpConfig.videoInitBitrate = 1000;
        rtmpConfig.videoTargetBitrate = 1500;
        rtmpConfig.videoMinBitrate = 600;
        // 创建直播推流配置
        AliLiveConfig mAliLiveConfig = new AliLiveConfig(rtmpConfig);
        // 初始化分辨率、帧率、是否开启高清预览、暂停后默认显示图片
        mAliLiveConfig.videoFPS = 20;
        mAliLiveConfig.videoPushProfile = AliLiveConstants.AliLiveVideoPushProfile.AliLiveVideoProfile_540P;
        mAliLiveConfig.enableHighDefPreview = false;
//        mAliLiveConfig.pauseImage = bitmap;
        mAliLiveConfig.accountId = "";
        mAliLiveEngine = AliLiveEngine.create(context, mAliLiveConfig);
        mAliLiveRenderView = mAliLiveEngine.createRenderView(false);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        String method = call.method;
        if (TextUtils.isEmpty(method)) {
            result.notImplemented();
            return;
        }

        if ("startPreview".equals(method)) {
            // 开启预览
            // 设置预览显示模式
            mAliLiveEngine.setPreviewMode(AliLiveRenderModeAuto, AliLiveRenderMirrorModeOnlyFront);
            // 开始预览
            mAliLiveEngine.startPreview(mAliLiveRenderView);
            result.success("");
            return;
        }

        if ("startLive".equals(method)) {
            // 开启直播
            String pushUrl = call.argument("pushUrl");
            mAliLiveEngine.startPush(pushUrl);
            result.success("");
            return;
        }

        if ("closeLive".equals(method)) {
            // 关闭直播
            // 停止预览
            mAliLiveEngine.stopPreview();
            // 停止推流
            mAliLiveEngine.stopPush();
            // 销毁liveEngine
            mAliLiveEngine.destroy();
            mAliLiveEngine = null;
            result.success("");
        }
    }

    @Override
    public View getView() {
        return mAliLiveRenderView;
    }

    @Override
    public void dispose() {
        channel.destroy();
    }
}
