#import "LiveView.h"
#import <AliyunPlayer/AliyunPlayer.h>
#import <AliLiveSdk/AliLiveSdk.h>
#import "Constants.h"

@interface LiveView ()<FlutterStreamHandler, AliLivePushInfoStatusDelegate>
@property (nonatomic, strong) AliLiveRenderView *renderView;
@property (nonatomic, strong, nullable) AliLiveEngine *engine;
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
        NSDictionary *dic = call.arguments;

        if ([CMD_START_PREVIEW isEqualToString:method]) {
            // 开始预览
            if (nil == self.engine) {
                result(@"engine为nil");
                return;
            }

            [self.engine startPreview:self.renderView];
            result(@"预览成功");
            return;
        }

        if ([CMD_SWITCH_CAMERA isEqualToString:method]) {
            // 切换相机
            if (nil == self.engine) {
                result(@"engine为nil");
                return;
            }

            [self.engine switchCamera];
            result(@"切换相机");
            return;
        }

        if ([CMD_START_LIVE isEqualToString:method]) {
            // 开始推流
            if (nil == self.engine) {
                result(@"engine为nil");
                return;
            }

            self.playurl = dic[@"pushStreamUrl"];
            [self.engine startPushWithURL:self.playurl];
            result(@"推流成功");
            return;
        }

        if ([CMD_PAUSE_LIVE isEqualToString:method]) {
            // 暂停推流
            if (nil == self.engine) {
                result(@"engine为nil");
                return;
            }

            [self.engine pausePush];
            result(@"暂停推流");
            return;
        }

        if ([CMD_RESUME_LIVE isEqualToString:method]) {
            // 恢复推流
            if (nil == self.engine) {
                result(@"engine为nil");
                return;
            }

            [self.engine resumePush];
            result(@"恢复推流");
            return;
        }

        if ([CMD_CLOSE_LIVE isEqualToString:method]) {
            // 结束推流流
            if (nil == self.engine) {
                result(@"engine为nil");
                return;
            }

            [self.engine stopPush];
            [self.engine stopPreview];
            [self.engine destorySdk];
            self.engine = nil;
            result(@"关闭成功");
            return;
        }

        if ([CMD_AGAIN_LIVE isEqualToString:method]) {
            // 重新推流
            if (nil == self.engine) {
                result(@"engine为nil");
                return;
            }

            self.playurl = dic[@"pushStreamUrl"];

            [self.engine stopPush];
            [self.engine startPushWithURL:self.playurl];
            result(@"重新推流成功");
            return;
        }
    }];

    [eventChannel setStreamHandler:self];
}

- (void)createView:(id)args {
    NSDictionary *dic = args;
    int resolutionType = [[NSString stringWithFormat:@"%@", dic[@"resolutionType"]] intValue];
    NSLog(@"@resolutionType: %d", resolutionType);
    AliLiveConfig * config = [[AliLiveConfig alloc] init];
    if (resolutionType == 1) {
        config.videoProfile = AliLiveVideoProfile_480P;
    } else if (resolutionType == 3) {
        config.videoProfile = AliLiveVideoProfile_1080P;
    } else {
        config.videoProfile = AliLiveVideoProfile_720P;
    }
    config.videoFPS = 25;
    config.enableHighDefPreview = true;
    config.autoFocus = true;
    config.videoInitBitrate = 1000;
    config.videoTargetBitrate = 1500;
    config.videoMinBitrate = 600;
//    config.pauseImage = [UIImage imageNamed:@"background_img.png"];
    self.engine = [[AliLiveEngine alloc] initWithConfig:config];
    [self.engine setAudioSessionOperationRestriction:AliLiveAudioSessionOperationRestrictionDeactivateSession];

    [self.engine setStatusDelegate:self];
//    [engine setNetworkDelegate:self];
}

- (nonnull UIView *)view {
    return self.renderView;
}

- (void)onLiveSdkError:(AliLiveEngine *)publisher error:(AliLiveError *)error {
    NSLog(@"推流错误=> code: %lu, msg: %@", (unsigned long)error.errorCode, error.errorDescription);

    self.eventSink([self getCallbackJson:@"error" info:[NSString stringWithFormat:@"%ld", (long)error.errorCode]]);
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
