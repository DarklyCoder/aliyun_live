//
//  Constants.m
//  aliyun_live
//
//  Created by admin on 2021/3/8.
//

#import <Foundation/Foundation.h>
#import <Constants.h>

NSString *const PREFIX_NAME = @"com.pulin.aliyun_live/";

NSString *const METHOD_CHANNEL_NAME = @"com.pulin.aliyun_live/ali_live_";
NSString *const EVENT_CHANNEL_NAME = @"com.pulin.aliyun_live/ali_live_event_";
NSString *const LIVE_VIEW_TYPE_ID = @"com.pulin.aliyun_live/AliLiveView";

NSString *const CMD_START_PREVIEW = @"startPreview"; // 开始预览
NSString *const CMD_SWITCH_CAMERA = @"switchCamera"; // 切换相机
NSString *const CMD_START_LIVE = @"startLive"; // 开始推流
NSString *const CMD_PAUSE_LIVE = @"pauseLive"; // 暂停推流
NSString *const CMD_RESUME_LIVE = @"resumeLive"; // 恢复推流
NSString *const CMD_CLOSE_LIVE = @"closeLive"; // 结束推流
NSString *const CMD_AGAIN_LIVE = @"againLive"; // 重新推流

NSString *const PLAYER_METHOD_CHANNEL_NAME = @"com.pulin.aliyun_live/ali_player_";
NSString *const PLAYER_EVENT_CHANNEL_NAME = @"com.pulin.aliyun_live/ali_player_event_";
NSString *const PLAYER_VIEW_TYPE_ID = @"com.pulin.aliyun_live/AliPlayerView";

NSString *const CMD_START_PLAY = @"startPlay"; // 开始拉流
NSString *const CMD_PAUSE_PLAY = @"pausePlay"; // 暂停拉流
NSString *const CMD_RESUME_PLAY = @"resumePlay"; // 恢复拉流
NSString *const CMD_PLAY_AGAIN = @"playAgain"; // 重新拉流
NSString *const CMD_CLOSE_PLAY = @"closePlay"; // 结束拉流
