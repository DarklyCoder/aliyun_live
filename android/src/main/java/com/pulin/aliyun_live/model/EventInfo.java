package com.pulin.aliyun_live.model;

/**
 * 消息详情，用于想flutter层传送数据
 */
public class EventInfo {
    public String type;
    public String info;

    @Override
    public String toString() {
        return "{" +
                "\"type\":\"" + type + "\"" +
                ", \"info\":\"" + info + "\"" +
                '}';
    }
}
