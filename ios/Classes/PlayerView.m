#import "PlayerView.h"
#import <AliyunPlayer/AliyunPlayer.h>
#import <AliLiveSdk/AliLiveSdk.h>
#import "Constants.h"

@interface PlayerView ()<FlutterStreamHandler>
@property (nonatomic, strong) UIView *renderView;
@property (nonatomic, strong) AliPlayer *player;
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

    [self createView];
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

        if ([CMD_START_PLAY isEqualToString:method]) {
            // 开始拉流
            NSString *playurl = call.arguments;
            AVPUrlSource *source = [[AVPUrlSource alloc] urlWithString:playurl];
            [self.player setUrlSource:source];
            [self.player prepare];

            result(@"播放成功");
            return;
        }

        if ([CMD_STOP_PLAY isEqualToString:method]) {
            // 暂停拉流
            [self.player pause];
            result(@"暂停成功");
            return;
        }

        if ([CMD_PLAY_AGAIN isEqualToString:method]) {
            // 重新拉流
            [self.player stop];

            NSString *playurl = call.arguments;
            AVPUrlSource *source = [[AVPUrlSource alloc] urlWithString:playurl];
            [self.player setUrlSource:source];
            [self.player prepare];

            result(@"重新播放成功");
            return;
        }

        if ([CMD_CLOSE_PLAY isEqualToString:method]) {
            // 结束拉流
            if (self.player.rate > 0) {
                [self.player stop];
            }
            [self.player destroy];
            result(@"关闭成功");
            return;
        }
    }];

    [eventChannel setStreamHandler:self];
}

- (void)createView {
    self.player = [AliPlayer new];
    self.player.autoPlay = YES;
    self.player.playerView = self.renderView;
}

- (nonnull UIView *)view {
    return self.renderView;
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
