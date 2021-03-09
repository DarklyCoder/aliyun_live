package com.pulin.aliyun_live.view;

import android.content.Context;
import android.text.TextUtils;
import android.view.View;

import androidx.annotation.NonNull;

import com.alivc.live.AliLiveCallback;
import com.alivc.live.AliLiveConfig;
import com.alivc.live.AliLiveConstants;
import com.alivc.live.AliLiveEngine;
import com.alivc.live.AliLiveError;
import com.alivc.live.AliLiveRTMPConfig;
import com.alivc.live.AliLiveRenderView;
import com.alivc.live.bean.AliLiveLocalVideoStats;
import com.alivc.live.bean.AliLiveRemoteAudioStats;
import com.alivc.live.bean.AliLiveRemoteVideoStats;
import com.alivc.live.bean.AliLiveStats;
import com.pulin.aliyun_live.ALog;
import com.pulin.aliyun_live.Constants;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import static com.alivc.live.AliLiveConstants.AliLiveRenderMirrorMode.AliLiveRenderMirrorModeOnlyFront;
import static com.alivc.live.AliLiveConstants.AliLiveRenderMode.AliLiveRenderModeAuto;

/**
 * 直播组件
 */
public class LiveView extends BaseView {

    private AliLiveEngine mAliLiveEngine;
    private AliLiveRenderView mAliLiveRenderView;

    LiveView(BinaryMessenger messenger, Context context, int viewId, Object args) {
        super(messenger, context, viewId, args);
    }

    @Override
    String createMethodChannelName() {
        return Constants.METHOD_CHANNEL_NAME;
    }

    @Override
    String createEventChannelName() {
        return Constants.EVENT_CHANNEL_NAME;
    }

    @Override
    protected void createView(Object args) {
        // 创建RTMP相关配置对象
        AliLiveRTMPConfig rtmpConfig = new AliLiveRTMPConfig();
        // 初始化码率配置
        rtmpConfig.videoInitBitrate = 1000;
        rtmpConfig.videoTargetBitrate = 1500;
        rtmpConfig.videoMinBitrate = 600;
        // 创建直播推流配置
        AliLiveConfig mAliLiveConfig = new AliLiveConfig(rtmpConfig);
        // 初始化分辨率、帧率、是否开启高清预览、暂停后默认显示图片
        mAliLiveConfig.videoPushProfile = AliLiveConstants.AliLiveVideoPushProfile.AliLiveVideoProfile_720P;
        mAliLiveConfig.videoFPS = 20;
        mAliLiveConfig.enableHighDefPreview = true;
//        mAliLiveConfig.pauseImage = bitmap;
        mAliLiveEngine = AliLiveEngine.create(context, mAliLiveConfig);
        mAliLiveRenderView = mAliLiveEngine.createRenderView(false);

        // 设置推流网络状态相关回调
        mAliLiveEngine.setNetworkCallback(new AliLiveCallback.NetworkCallback() {
            @Override
            public void onNetworkStatusChange(AliLiveConstants.AliLiveNetworkStatus aliLiveNetworkStatus) {

            }

            @Override
            public void onNetworkPoor() {

            }

            @Override
            public void onConnectRecovery() {

            }

            @Override
            public void onReconnectStart() {

            }

            @Override
            public void onConnectionLost() {

            }

            @Override
            public void onReconnectStatus(boolean b) {

            }
        });
        // 设置推流数据回调。
        mAliLiveEngine.setStatsCallback(new AliLiveCallback.StatsCallback() {
            @Override
            public void onLiveTotalStats(AliLiveStats aliLiveStats) {

            }

            @Override
            public void onLiveLocalVideoStats(AliLiveLocalVideoStats aliLiveLocalVideoStats) {

            }

            @Override
            public void onLiveRemoteVideoStats(AliLiveRemoteVideoStats aliLiveRemoteVideoStats) {

            }

            @Override
            public void onLiveRemoteAudioStats(AliLiveRemoteAudioStats aliLiveRemoteAudioStats) {

            }
        });
        // 设置推流状态相关回调
        mAliLiveEngine.setStatusCallback(new AliLiveCallback.StatusCallback() {
            @Override
            public void onLiveSdkError(AliLiveEngine aliLiveEngine, AliLiveError aliLiveError) {

            }

            @Override
            public void onLiveSdkWarning(AliLiveEngine aliLiveEngine, int i) {

            }

            @Override
            public void onPreviewStarted(AliLiveEngine aliLiveEngine) {

            }

            @Override
            public void onPreviewStopped(AliLiveEngine aliLiveEngine) {

            }

            @Override
            public void onFirstVideoFramePreviewed(AliLiveEngine aliLiveEngine) {

            }

            @Override
            public void onLivePushStarted(AliLiveEngine aliLiveEngine) {

            }

            @Override
            public void onLivePushStopped(AliLiveEngine aliLiveEngine) {

            }

            @Override
            public void onAudioFocusChanged(int i) {

            }

            @Override
            public void onBGMStateChanged(AliLiveEngine aliLiveEngine, AliLiveConstants.AliLiveAudioPlayingStateCode aliLiveAudioPlayingStateCode, AliLiveConstants.AliLiveAudioPlayingErrorCode aliLiveAudioPlayingErrorCode) {

            }
        });
        ALog.d("LiveView Create Complete!");
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        String method = call.method;
        if (TextUtils.isEmpty(method)) {
            result.notImplemented();
            return;
        }

        if (Constants.CMD_START_PREVIEW.equals(method)) {
            ALog.d("开启预览: " + call.arguments);
            // 设置预览显示模式
            mAliLiveEngine.setPreviewMode(AliLiveRenderModeAuto, AliLiveRenderMirrorModeOnlyFront);
            // 开始预览
            mAliLiveEngine.startPreview(mAliLiveRenderView);
            result.success("");
            return;
        }

        if (Constants.CMD_SWITCH_CAMERA.equals(method)) {
            ALog.d("切换相机: " + call.arguments);
            mAliLiveEngine.switchCamera();
            result.success("");
            return;
        }

        if (Constants.CMD_START_LIVE.equals(method)) {
            ALog.d("开启直播: " + call.arguments);
            String pushUrl = call.arguments.toString();
            mAliLiveEngine.startPush(pushUrl);
            result.success("");
            return;
        }

        if (Constants.CMD_PAUSE_LIVE.equals(method)) {
            ALog.d("暂停直播: " + call.arguments);
            mAliLiveEngine.pausePush();
            result.success("");
            return;
        }

        if (Constants.CMD_RESUME_LIVE.equals(method)) {
            ALog.d("恢复直播: " + call.arguments);
            mAliLiveEngine.resumePush();
            result.success("");
            return;
        }

        if (Constants.CMD_CLOSE_LIVE.equals(method)) {
            ALog.d("关闭直播: " + call.arguments);
            closeLive();
            result.success("");
        }
    }

    @Override
    public View getView() {
        return mAliLiveRenderView;
    }

    @Override
    public void dispose() {
        super.dispose();
        closeLive();
    }

    private void closeLive() {
        // 停止预览
        mAliLiveEngine.stopPreview();
        // 停止推流
        mAliLiveEngine.stopPush();
        // 销毁liveEngine
        mAliLiveEngine.destroy();
        mAliLiveEngine = null;
    }
}
