//
//  Constants.h
//  aliyun_live
//
//  Created by admin on 2021/3/8.
//
#import <Foundation/Foundation.h>

extern NSString *const METHOD_CHANNEL_NAME;
extern NSString *const EVENT_CHANNEL_NAME;
extern NSString *const LIVE_VIEW_TYPE_ID;

extern NSString *const CMD_START_PREVIEW; // 开始预览
extern NSString *const CMD_SWITCH_CAMERA; // 切换相机
extern NSString *const CMD_START_LIVE; // 开始推流
extern NSString *const CMD_PAUSE_LIVE; // 暂停推流
extern NSString *const CMD_RESUME_LIVE; // 恢复推流
extern NSString *const CMD_CLOSE_LIVE; // 结束推流
extern NSString *const CMD_AGAIN_LIVE; // 重新推流

extern NSString *const PLAYER_METHOD_CHANNEL_NAME;
extern NSString *const PLAYER_EVENT_CHANNEL_NAME;
extern NSString *const PLAYER_VIEW_TYPE_ID;

extern NSString *const CMD_START_PLAY; // 开始拉流
extern NSString *const CMD_PAUSE_PLAY; // 暂停拉流
extern NSString *const CMD_RESUME_PLAY; // 恢复拉流
extern NSString *const CMD_PLAY_AGAIN; // 重新拉流
extern NSString *const CMD_CLOSE_PLAY; // 结束拉流
