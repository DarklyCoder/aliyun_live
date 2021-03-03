#import "LiveView.h"
#import <AliyunPlayer/AliyunPlayer.h>
#import <AliLiveSdk/AliLiveSdk.h>

@interface LiveView ()
@property (nonatomic, strong) AliLiveRenderView *renderView;
@property (nonatomic, strong) AliLiveEngine *engine;
@property (nonatomic, strong) AliPlayer *player;
@property (nonatomic, strong) NSString *playurl;
@property (nonatomic, strong) NSObject<FlutterBinaryMessenger> *_messenger;
@property (nonatomic) int64_t _viewId;
@end

@implementation LiveView

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger> *)messenger frame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args {
    self = [super init];
    if (self) {
        self._viewId = viewId;
        self._messenger = messenger;
        self.renderView = [[AliLiveRenderView alloc] init];
    }

    [self initChannel];
    [self createView];
    return self;
}

- (void)initChannel {
    NSString *name = [NSString stringWithFormat:@"com.pulin.aliyun_live/ali_live_%lld", self._viewId];
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:name binaryMessenger:self._messenger];

    [channel setMethodCallHandler:^(FlutterMethodCall *_Nonnull call, FlutterResult _Nonnull result) {
        NSString *method = call.method;
        NSLog(@"接收到数据：%@", method);
        if ([@"startPreview" isEqualToString:method]) {
            // 开始预览
            [self.engine startPreview:self.renderView];

            result(@"预览成功");
            return;
        }
        if ([@"startLive" isEqualToString:method]) {
            // 开始推流
            self.playurl = call.arguments;
            [self.engine startPushWithURL:@""];
            result(@"推流成功");
            return;
        }
        if ([@"closeLive" isEqualToString:method]) {
            // 结束拉流
            [self.engine stopPush];
            [self.engine stopPreview];
            [self.engine destorySdk];
            self.engine = nil;
            result(@"关闭成功");
            return;
        }
    }];
}

- (void)createView {
    AliLiveConfig *config = [[AliLiveConfig alloc] init];
    config.videoProfile = AliLiveVideoProfile_540P;
    config.videoFPS = 20;
//    config.pauseImage = [UIImage imageNamed:@"background_img.png"];
    config.accountID = @"";
    self.engine = [[AliLiveEngine alloc] initWithConfig:config];
    [self.engine setAudioSessionOperationRestriction:AliLiveAudioSessionOperationRestrictionDeactivateSession];

//    [engine setRtsDelegate:self];
//    [engine setStatusDelegate:self];
}

- (nonnull UIView *)view {
    return self.renderView;
}

@end
