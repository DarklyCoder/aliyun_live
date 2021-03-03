package com.pulin.aliyun_live;

import android.content.Context;

import io.flutter.Log;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class PlayerViewFactory extends PlatformViewFactory {

    private final BinaryMessenger messenger;

    PlayerViewFactory(BinaryMessenger messenger) {
        super(StandardMessageCodec.INSTANCE);
        this.messenger = messenger;
    }

    @Override
    public PlatformView create(Context context, int viewId, Object args) {
        return new PlayerView(messenger, context, viewId, args);
    }
}
