#import "LiveView.h"
#import <AliyunPlayer/AliyunPlayer.h>
#import <AliLiveSdk/AliLiveSdk.h>
#import "Constants.h"

@interface LiveView ()<FlutterStreamHandler>
@property (nonatomic, strong) AliLiveRenderView *renderView;
@property (nonatomic, strong) AliLiveEngine *engine;
@property (nonatomic, strong) AliPlayer *player;
@property (nonatomic, strong) NSString *playurl;
@property (nonatomic, strong) NSObject<FlutterBinaryMessenger> *_messenger;
@property (nonatomic) int64_t _viewId;
@property (nonatomic, strong) FlutterEventSink eventSink;
@end

@implementation LiveView

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
    NSString *channelName = [NSString stringWithFormat:@"%@%lld", METHOD_CHANNEL_NAME, self._viewId];
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:self._messenger];

    NSString *eventName = [NSString stringWithFormat:@"%@%lld", EVENT_CHANNEL_NAME, self._viewId];
    FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:eventName binaryMessenger:self._messenger];

    [channel setMethodCallHandler:^(FlutterMethodCall *_Nonnull call, FlutterResult _Nonnull result) {
        NSString *method = call.method;
        NSLog(@"接收到数据：%@", method);
        if ([CMD_START_PREVIEW isEqualToString:method]) {
            // 开始预览
            [self.engine startPreview:self.renderView];

            result(@"预览成功");
            return;
        }

        if ([CMD_SWITCH_CAMERA isEqualToString:method]) {
            // 切换相机
            [self.engine switchCamera];

            result(@"切换相机");
            return;
        }

        if ([CMD_START_LIVE isEqualToString:method]) {
            // 开始推流
            self.playurl = call.arguments;
            [self.engine startPushWithURL:self.playurl];
            result(@"推流成功");
            return;
        }

        if ([CMD_PAUSE_LIVE isEqualToString:method]) {
            // 暂停推流
            [self.engine pausePush];
            result(@"暂停推流");
            return;
        }

        if ([CMD_RESUME_LIVE isEqualToString:method]) {
            // 恢复推流
            [self.engine resumePush];
            result(@"恢复推流");
            return;
        }

        if ([CMD_CLOSE_LIVE isEqualToString:method]) {
            // 结束拉流
            [self.engine stopPush];
            [self.engine stopPreview];
            [self.engine destorySdk];
            self.engine = nil;
            result(@"关闭成功");
            return;
        }
    }];

    [eventChannel setStreamHandler:self];
}

- (void)createView:(id)args {
    AliLiveConfig *config = [[AliLiveConfig alloc] init];
    config.videoProfile = AliLiveVideoProfile_540P;
    config.videoFPS = 20;
//    config.pauseImage = [UIImage imageNamed:@"background_img.png"];
    self.engine = [[AliLiveEngine alloc] initWithConfig:config];
    [self.engine setAudioSessionOperationRestriction:AliLiveAudioSessionOperationRestrictionDeactivateSession];

//    [engine setRtsDelegate:self];
//    [engine setStatusDelegate:self];
//    [engine setNetworkDelegate:self];
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
