#import "PlayerView.h"
#import <AliyunPlayer/AliyunPlayer.h>
#import <AliLiveSdk/AliLiveSdk.h>
#import "Constants.h"

@interface PlayerView ()<FlutterStreamHandler, AVPDelegate>
@property (nonatomic, strong) UIView *renderView;
@property (nonatomic, strong, nullable) AliPlayer *player;
@property (nonatomic, strong) NSObject<FlutterBinaryMessenger> *_messenger;
@property (nonatomic) int64_t _viewId;
@property (nonatomic, strong) FlutterEventSink eventSink;
@end

@implementation PlayerView

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger> *)messenger frame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args {
    self = [super init];
    if (self) {
        self._viewId = viewId;
        self._messenger = messenger;
        self.renderView = [[AliLiveRenderView alloc] init];
    }

    [self createView:args];
    [self initChannel];

    return self;
}

- (void)initChannel {
    NSString *channelName = [NSString stringWithFormat:@"%@%lld", PLAYER_METHOD_CHANNEL_NAME, self._viewId];
    FlutterMethodChannel *methodChannel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:self._messenger];

    NSString *eventName = [NSString stringWithFormat:@"%@%lld", PLAYER_EVENT_CHANNEL_NAME, self._viewId];
    FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:eventName binaryMessenger:self._messenger];

    [methodChannel setMethodCallHandler:^(FlutterMethodCall *_Nonnull call, FlutterResult _Nonnull result) {
        NSString *method = call.method;
        NSLog(@"接收到数据：%@", method);
        NSDictionary *dic = call.arguments;

        if ([CMD_START_PLAY isEqualToString:method]) {
            // 开始拉流
            if (nil == self.player) {
                result(@"player为nil");
                return;
            }

            NSString *playurl = dic[@"playStreamUrl"];
            AVPUrlSource *source = [[AVPUrlSource alloc] urlWithString:playurl];
            [self.player setUrlSource:source];
            [self.player prepare];

            result(@"播放成功");
            return;
        }

        if ([CMD_PAUSE_PLAY isEqualToString:method]) {
            // 暂停拉流
            if (nil == self.player) {
                result(@"player为nil");
                return;
            }

            [self.player pause];
            result(@"暂停成功");
            return;
        }

        if ([CMD_RESUME_PLAY isEqualToString:method]) {
            // 恢复拉流
            if (nil == self.player) {
                result(@"player为nil");
                return;
            }

            [self.player start];
            result(@"恢复成功");
            return;
        }

        if ([CMD_PLAY_AGAIN isEqualToString:method]) {
            // 重新拉流
            if (nil == self.player) {
                result(@"player为nil");
                return;
            }

            [self.player stop];

            NSString *playurl = dic[@"playStreamUrl"];
            AVPUrlSource *source = [[AVPUrlSource alloc] urlWithString:playurl];
            [self.player setUrlSource:source];
            [self.player prepare];

            result(@"重新播放成功");
            return;
        }

        if ([CMD_CLOSE_PLAY isEqualToString:method]) {
            // 结束拉流
            if (nil == self.player) {
                result(@"player为nil");
                return;
            }

            if (self.player.rate > 0) {
                [self.player stop];
            }
            [self.player destroy];
            self.player = nil;
            result(@"关闭成功");
            return;
        }
    }];

    [eventChannel setStreamHandler:self];
}

- (void)createView:(id)args {
//    NSDictionary *dic = args;
    self.player = [AliPlayer new];
    self.player.autoPlay = YES;
    self.player.playerView = self.renderView;
    self.player.scalingMode = AVP_SCALINGMODE_SCALEASPECTFILL;
    self.player.delegate = self;
}

- (nonnull UIView *)view {
    return self.renderView;
}

/**
 @brief 错误代理回调
 @param player 播放器player指针
 @param errorModel 播放器错误描述，参考AliVcPlayerErrorModel
 */
- (void)onError:(AliPlayer *)player errorModel:(AVPErrorModel *)errorModel {
    NSLog(@"播放错误=> code: %lu, msg: %@", (unsigned long)errorModel.code, errorModel.message);

    self.eventSink([self getCallbackJson:@"error" info:errorModel.message]);
}

/**
 @brief 播放器事件回调
 @param player 播放器player指针
 @param eventType 播放器事件类型，@see AVPEventType
 */
- (void)onPlayerEvent:(AliPlayer *)player eventType:(AVPEventType)eventType {
    switch (eventType) {
        case AVPEventLoadingStart:
            self.eventSink([self getCallbackJson:@"loading" info:@"start"]);
            break;

        case AVPEventLoadingEnd:
            self.eventSink([self getCallbackJson:@"loading" info:@"end"]);
            break;

        default:
            break;
    }
}

- (NSString *)getCallbackJson:(NSString *)type info:(NSString *)info {
    NSDictionary *dic = @{ @"type": type,
                           @"info": info };
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    return jsonStr;
}

#pragma mark - FlutterStreamHandler
- (FlutterError *_Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(FlutterEventSink)eventSink {
    self.eventSink = eventSink;
    return nil;
}

- (FlutterError *_Nullable)onCancelWithArguments:(id _Nullable)arguments {
    return nil;
}

@end
