package com.pulin.aliyun_live;

import android.util.Log;

public final class ALog {

    private static final String TAG = "LiveLog";
    public static boolean open = true;

    public static void d(String msg) {
        if (open) {
            Log.d(TAG, msg);
        }
    }

    public static void e(String msg) {
        if (open) {
            Log.e(TAG, msg);
        }
    }

    public static void e(Throwable e) {
        if (open) {
            Log.e(TAG, "", e);
        }
    }

}
