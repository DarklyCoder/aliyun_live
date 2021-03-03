package com.pulin.aliyun_live;

import android.content.Context;

import java.util.HashMap;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class LiveViewFactory extends PlatformViewFactory {

    private final BinaryMessenger messenger;

    LiveViewFactory(BinaryMessenger messenger) {
        super(StandardMessageCodec.INSTANCE);
        this.messenger = messenger;
    }

    @Override
    public PlatformView create(Context context, int viewId, Object args) {
        return new LiveView(messenger, context, viewId, (HashMap) args);
    }
}
