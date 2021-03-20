package com.pulin.aliyun_live.model;

import com.pulin.aliyun_live.ALog;

import java.util.Map;

/**
 * 直播配置
 */
public class LiveConfig {
    public String pushStreamUrl; // 推流地址
    public String playStreamUrl; // 播流地址
    public String cover; // 封面地址
    public int resolutionType = 2; // 分辨率类型，1:640*480，2:1280*720，3:1920*1080
    public int frameType = 3; // 帧率类型，1：30fps，2：60fps 3: 25fps
    public int rateType = 2; // 码率类型，1：1500kbps，2：2000kbps，3：3000kbps
    public int codeType = 1; // 编码类型，1：硬件，2：软件

    /**
     * 解析配置
     */
    public static LiveConfig parseArguments(Object args) {
        ALog.d("parseArguments: " + args.toString());
        
        LiveConfig config = new LiveConfig();
        if (args instanceof Map) {
            Map<String, Object> map = (Map) args;
            config.pushStreamUrl = null == map.get("pushStreamUrl") ? "" : (String) map.get("pushStreamUrl");
            config.playStreamUrl = null == map.get("playStreamUrl") ? "" : (String) map.get("playStreamUrl");
            config.cover = null == map.get("cover") ? "" : (String) map.get("cover");
            config.resolutionType = null == map.get("resolutionType") ? 2 : (int) map.get("resolutionType");
            config.frameType = null == map.get("frameType") ? 3 : (int) map.get("frameType");
            config.rateType = null == map.get("rateType") ? 2 : (int) map.get("rateType");
            config.codeType = null == map.get("codeType") ? 1 : (int) map.get("codeType");
        }

        return config;
    }
}
