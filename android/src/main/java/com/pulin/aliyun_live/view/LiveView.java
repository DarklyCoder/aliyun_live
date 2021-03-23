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
import com.pulin.aliyun_live.ALog;
import com.pulin.aliyun_live.Constants;
import com.pulin.aliyun_live.model.EventInfo;
import com.pulin.aliyun_live.model.LiveConfig;

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
    private LiveConfig mLiveConfig; // 直播配置

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
        mLiveConfig = LiveConfig.parseArguments(args);
        initAliLiveConfig();
        initCallBack(false);
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
            ALog.d("开启预览");
            try {
                // 设置预览显示模式
                mAliLiveEngine.setPreviewMode(AliLiveRenderModeAuto, AliLiveRenderMirrorModeOnlyFront);
                // 开始预览
                mAliLiveEngine.startPreview(mAliLiveRenderView);
                result.success("");
            } catch (Exception e) {
                ALog.e(e);
                result.error("-1", "开启预览失败", e);
            }
            return;
        }

        if (Constants.CMD_SWITCH_CAMERA.equals(method)) {
            ALog.d("切换相机");
            try {
                mAliLiveEngine.switchCamera();
                result.success("");

            } catch (Exception e) {
                ALog.e(e);
                result.error("-1", "切换相机失败", e);
            }
            return;
        }

        if (Constants.CMD_START_LIVE.equals(method)) {
            ALog.d("开启直播: " + call.arguments);
            try {
                mLiveConfig = LiveConfig.parseArguments(call.arguments);
                mAliLiveEngine.startPush(mLiveConfig.pushStreamUrl);
                result.success("");

            } catch (Exception e) {
                ALog.e(e);
                result.error("-1", "推流失败", e);
            }
            return;
        }

        if (Constants.CMD_PAUSE_LIVE.equals(method)) {
            ALog.d("暂停直播");
            try {
                mAliLiveEngine.pausePush();
                result.success("");

            } catch (Exception e) {
                ALog.e(e);
                result.error("-1", "暂停直播失败", e);
            }
            return;
        }

        if (Constants.CMD_RESUME_LIVE.equals(method)) {
            ALog.d("恢复直播");
            try {
                mAliLiveEngine.resumePush();
                result.success("");

            } catch (Exception e) {
                ALog.e(e);
                result.error("-1", "恢复直播失败", e);
            }
            return;
        }

        if (Constants.CMD_CLOSE_LIVE.equals(method)) {
            ALog.d("关闭直播");
            closeLive();
            result.success("");
            return;
        }

        if (Constants.CMD_AGAIN_LIVE.equals(method)) {
            ALog.d("重新直播: " + call.arguments);
            mLiveConfig = LiveConfig.parseArguments(call.arguments);
//            initCallBack(true);
//            initAliLiveConfig();
//            initCallBack(false);

            try {
                mAliLiveEngine.stopPush();
                mAliLiveEngine.startPush(mLiveConfig.pushStreamUrl);
                result.success("");

            } catch (Exception e) {
                ALog.e(e);
                result.error("-1", "重新直播失败", e);
            }
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

    /**
     * 初始化配置，推流之前需要配置
     */
    private void initAliLiveConfig() {
        // 创建RTMP相关配置对象
        AliLiveRTMPConfig rtmpConfig = new AliLiveRTMPConfig();
        // 初始化码率配置
        rtmpConfig.videoInitBitrate = 1000;
        rtmpConfig.videoTargetBitrate = 1500;
        rtmpConfig.videoMinBitrate = 600;
        // 创建直播推流配置
        AliLiveConfig aliLiveConfig = new AliLiveConfig(rtmpConfig);
//        mAliLiveConfig.videoRenderMode = AliLiveRenderModeAuto;
        aliLiveConfig.pushMirror = AliLiveConstants.AliLiveRenderMirrorMode.AliLiveRenderMirrorModeOnlyFront;
        // 初始化分辨率、帧率、是否开启高清预览、暂停后默认显示图片
        if (mLiveConfig.resolutionType == 1) {
            aliLiveConfig.videoPushProfile = AliLiveConstants.AliLiveVideoPushProfile.AliLiveVideoProfile_480P;
        } else if (mLiveConfig.resolutionType == 3) {
            aliLiveConfig.videoPushProfile = AliLiveConstants.AliLiveVideoPushProfile.AliLiveVideoProfile_1080P;
        } else {
            aliLiveConfig.videoPushProfile = AliLiveConstants.AliLiveVideoPushProfile.AliLiveVideoProfile_720P;

        }
        aliLiveConfig.videoFPS = 25;
        aliLiveConfig.enableHighDefPreview = true;
        aliLiveConfig.autoFocus = true;
//        aliLiveConfig.pauseImage = bitmap;

        mAliLiveEngine = AliLiveEngine.create(context, aliLiveConfig);
        mAliLiveRenderView = mAliLiveEngine.createRenderView(false);
    }

    private void initCallBack(boolean clear) {
        if (clear) {
            mAliLiveEngine.setNetworkCallback(null);
            mAliLiveEngine.setStatusCallback(null);
            return;
        }

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
        // 设置推流状态相关回调
        mAliLiveEngine.setStatusCallback(new AliLiveCallback.StatusCallback() {
            @Override
            public void onLiveSdkError(AliLiveEngine aliLiveEngine, AliLiveError aliLiveError) {
                ALog.e("code: " + aliLiveError.errorCode + ", msg: " + aliLiveError.errorDescription);
                EventInfo info = new EventInfo();
                info.type = "error";
                info.info = "" + aliLiveError.errorCode;

                callback(info);
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
    }

    private void closeLive() {
        if (null == mAliLiveEngine) {
            ALog.d("直播已关闭！");
            return;
        }

        try {
            // 停止预览
            mAliLiveEngine.stopPreview();
            // 停止推流
            mAliLiveEngine.stopPush();
            // 销毁liveEngine
            mAliLiveEngine.destroy();
            mAliLiveEngine = null;

        } catch (Exception e) {
            ALog.e("直播关闭异常！");
            ALog.e(e);
        }
    }

}
