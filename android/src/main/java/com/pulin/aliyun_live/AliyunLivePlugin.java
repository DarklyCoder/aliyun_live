package com.pulin.aliyun_live;

import androidx.annotation.NonNull;

import com.pulin.aliyun_live.view.LiveViewFactory;
import com.pulin.aliyun_live.view.PlayerViewFactory;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.platform.PlatformViewRegistry;

/**
 * AliyunLivePlugin
 */
public class AliyunLivePlugin implements FlutterPlugin {

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        ALog.d("onAttachedToEngine");
        BinaryMessenger binaryMessenger = flutterPluginBinding.getBinaryMessenger();

        PlatformViewRegistry platformViewRegistry = flutterPluginBinding.getPlatformViewRegistry();

        LiveViewFactory liveFactory = new LiveViewFactory(binaryMessenger);
        platformViewRegistry.registerViewFactory(Constants.LIVE_VIEW_TYPE_ID, liveFactory);

        PlayerViewFactory playerFactory = new PlayerViewFactory(binaryMessenger);
        platformViewRegistry.registerViewFactory(Constants.PLAYER_VIEW_TYPE_ID, playerFactory);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        ALog.d("onDetachedFromEngine");
    }

}
