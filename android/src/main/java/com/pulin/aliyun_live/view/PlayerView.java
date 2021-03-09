package com.pulin.aliyun_live.view;

import android.content.Context;
import android.text.TextUtils;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.View;

import androidx.annotation.NonNull;

import com.aliyun.player.AliPlayer;
import com.aliyun.player.AliPlayerFactory;
import com.aliyun.player.IPlayer;
import com.aliyun.player.bean.ErrorInfo;
import com.aliyun.player.bean.InfoBean;
import com.aliyun.player.nativeclass.PlayerConfig;
import com.aliyun.player.source.UrlSource;
import com.pulin.aliyun_live.ALog;
import com.pulin.aliyun_live.Constants;
import com.pulin.aliyun_live.model.EventInfo;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * 播放组件
 */
public class PlayerView extends BaseView {

    private AliPlayer mAliPlayer;
    private SurfaceView mSurfaceView;

    PlayerView(BinaryMessenger messenger, Context context, int viewId, Object args) {
        super(messenger, context, viewId, args);
    }

    @Override
    String createMethodChannelName() {
        return Constants.PLAYER_METHOD_CHANNEL_NAME;
    }

    @Override
    String createEventChannelName() {
        return Constants.PLAYER_EVENT_CHANNEL_NAME;
    }

    @Override
    protected void createView(Object args) {
        // 创建播放器
        mAliPlayer = AliPlayerFactory.createAliPlayer(context);
        // 设置自动播放
        mAliPlayer.setAutoPlay(true);
        // 设置mMaxDelayTime，建议范围500~5000，值越小，直播时延越小，卡顿几率越大，根据需要自行决定
        PlayerConfig config = mAliPlayer.getConfig();
        config.mMaxDelayTime = 1000;
        // 设置网络超时时间，单位ms
        config.mNetworkTimeout = 5000;
        // 设置超时重试次数。每次重试间隔为networkTimeout。networkRetryCount=0则表示不重试，重试策略app决定，默认值为2
        config.mNetworkRetryCount = 3;
        mAliPlayer.setConfig(config);
        mAliPlayer.setOnErrorListener(new IPlayer.OnErrorListener() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                ALog.e("code: " + errorInfo.getCode() + ", msg: " + errorInfo.getMsg() + ", extra: " + errorInfo.getExtra());
                EventInfo info = new EventInfo();
                info.type = "error";
                info.info = "";

                callback(info);
            }
        });
        mAliPlayer.setOnInfoListener(new IPlayer.OnInfoListener() {
            @Override
            public void onInfo(InfoBean info) {
                ALog.d("code: " + info.getCode() + ", value: " + info.getExtraValue() + ", extra: " + info.getExtraMsg());
                EventInfo eventInfo = new EventInfo();
                eventInfo.type = "error";
                eventInfo.info = "";

                callback(eventInfo);
            }
        });
        mAliPlayer.setOnLoadingStatusListener(new IPlayer.OnLoadingStatusListener() {
            @Override
            public void onLoadingBegin() {
                ALog.d("onLoadingBegin");
                EventInfo info = new EventInfo();
                info.type = "loading";
                info.info = "start";
                callback(info);
            }

            @Override
            public void onLoadingProgress(int i, float v) {
                ALog.d("onLoadingProgress: " + i + "，" + v);
                EventInfo info = new EventInfo();
                info.type = "loading";
                info.info = "loading";
                info.info = String.valueOf(i);
                callback(info);
            }

            @Override
            public void onLoadingEnd() {
                ALog.d("onLoadingEnd");
                EventInfo info = new EventInfo();
                info.type = "loadingEnd";
                info.info = "end";
                callback(info);
            }
        });

        mSurfaceView = new SurfaceView(context);
        mSurfaceView.getHolder().addCallback(new SurfaceHolder.Callback() {
            @Override
            public void surfaceCreated(SurfaceHolder holder) {
                if (mAliPlayer != null) {
                    mAliPlayer.setSurface(holder.getSurface());
                }
            }

            @Override
            public void surfaceChanged(SurfaceHolder holder, int format, int width, int height) {
                if (mAliPlayer != null) {
                    mAliPlayer.surfaceChanged();
                }
            }

            @Override
            public void surfaceDestroyed(SurfaceHolder holder) {
                if (mAliPlayer != null) {
                    mAliPlayer.setSurface(null);
                }
            }
        });

        ALog.d("PlayerView Create Complete!");
    }

    @Override
    public void onMethodCall(@NonNull final MethodCall call, @NonNull MethodChannel.Result result) {
        String method = call.method;
        if (TextUtils.isEmpty(method)) {
            result.notImplemented();
            return;
        }

        if (Constants.CMD_START_PLAY.equals(method)) {
            ALog.d("开始拉流: " + call.arguments);
            String url = call.arguments.toString();
            startPlay(url);
            result.success("");
            return;
        }

        if (Constants.CMD_STOP_PLAY.equals(method)) {
            ALog.d("停止拉流");
            pausePlay();
            result.success("");
            return;
        }

        if (Constants.CMD_PLAY_AGAIN.equals(method)) {
            ALog.d("重新拉流");
            playAgain();
            result.success("");
            return;
        }

        if (Constants.CMD_CLOSE_PLAY.equals(method)) {
            ALog.d("关闭播放");
            closePlay();
            result.success("");
        }
    }

    @Override
    public View getView() {
        return mSurfaceView;
    }

    @Override
    public void dispose() {
        super.dispose();
        closePlay();
    }

    /**
     * 开始播放
     */
    private void startPlay(String url) {
        // 给播放器设置拉流地址
        UrlSource source = new UrlSource();
        source.setUri(url);
        mAliPlayer.setDataSource(source);
        mAliPlayer.prepare();
    }

    /**
     * 暂停播放
     */
    private void pausePlay() {
        mAliPlayer.pause();
    }

    /**
     * 重新播放
     */
    private void playAgain() {
        mAliPlayer.stop();
        mAliPlayer.start();
    }

    /**
     * 关闭播放
     */
    private void closePlay() {
        mAliPlayer.stop();
        mAliPlayer.setSurface(null);
        mAliPlayer.release();
        mAliPlayer = null;
    }
}