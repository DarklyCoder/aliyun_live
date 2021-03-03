package com.pulin.aliyun_live;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.View;

import androidx.annotation.NonNull;

import com.aliyun.player.AliPlayer;
import com.aliyun.player.AliPlayerFactory;
import com.aliyun.player.IPlayer;
import com.aliyun.player.bean.ErrorInfo;
import com.aliyun.player.nativeclass.PlayerConfig;
import com.aliyun.player.source.UrlSource;

import java.util.HashMap;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

/**
 * 播放组件
 */
public class PlayerView implements PlatformView, MethodChannel.MethodCallHandler {

    private Channel channel;
    private EventChannel.EventSink eventSink;
    private Context context;

    private AliPlayer mAliPlayer;
    private SurfaceView mSurfaceView;
    private Handler mHandler = new Handler(Looper.getMainLooper());

    PlayerView(BinaryMessenger messenger, Context context, int viewId, Object args) {
        this.channel = new Channel();
        this.context = context.getApplicationContext();
        initChannel(messenger, viewId);
        createView(context, args);
    }

    private void initChannel(BinaryMessenger messenger, int viewId) {
        channel.methodChannel = new MethodChannel(messenger, Constants.PLAYER_METHOD_CHANNEL_NAME + viewId);
        channel.eventChannel = new EventChannel(messenger, Constants.PLAYER_EVENT_CHANNEL_NAME + viewId);
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

    private void createView(Context context, Object args) {
        if(args instanceof HashMap){

        }

        // 创建播放器
        mAliPlayer = AliPlayerFactory.createAliPlayer(context.getApplicationContext());
        // 设置自动播放
        mAliPlayer.setAutoPlay(true);
        // 设置mMaxDelayTime，建议范围500~5000，值越小，直播时延越小，卡顿几率越大，根据需要自行决定
        PlayerConfig config = mAliPlayer.getConfig();
        config.mMaxDelayTime = 1000;
        //设置网络超时时间，单位ms
        config.mNetworkTimeout = 5000;
        //设置超时重试次数。每次重试间隔为networkTimeout。networkRetryCount=0则表示不重试，重试策略app决定，默认值为2
        config.mNetworkRetryCount=2;
        mAliPlayer.setConfig(config);
        mAliPlayer.setOnErrorListener(new IPlayer.OnErrorListener() {
            @Override
            public void onError(ErrorInfo errorInfo) {
//                eventSink.success();
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
    }

    @Override
    public void onMethodCall(@NonNull final MethodCall call, @NonNull MethodChannel.Result result) {
        String method = call.method;
        if (TextUtils.isEmpty(method)) {
            result.notImplemented();
            return;
        }

        if (Constants.CMD_START_PLAY.equals(method)) {
            // 开始拉流

            // 给播放器设置拉流地址
            String url = call.arguments.toString();
            UrlSource source = new UrlSource();
            source.setUri(url);
            mAliPlayer.setDataSource(source);
            mAliPlayer.prepare();

            result.success("");
            return;
        }

        if (Constants.CMD_STOP_PLAY.equals(method)) {
            // 停止拉流
            mAliPlayer.pause();
            return;
        }

        if (Constants.CMD_PLAY_AGAIN.equals(method)) {
            // 重新拉流
            mAliPlayer.stop();
            mAliPlayer.start();
            return;
        }

        if (Constants.CMD_CLOSE_PLAY.equals(method)) {
            // 关闭播放
            mAliPlayer.stop();
            mAliPlayer.setSurface(null);
            mAliPlayer.release();
            mAliPlayer = null;
            result.success("");
        }
    }

    @Override
    public View getView() {
        return mSurfaceView;
    }

    @Override
    public void dispose() {
        channel.destroy();
    }
}
