#import "PlayerView.h"
#import <AliyunPlayer/AliyunPlayer.h>
#import <AliLiveSdk/AliLiveSdk.h>

@interface PlayerView ()
@property (nonatomic, strong) UIView *renderView;
@property (nonatomic, strong) AliPlayer *player;
@property (nonatomic, strong) NSString *playurl;
@property (nonatomic, strong) NSObject<FlutterBinaryMessenger> *_messenger;
@property (nonatomic) int64_t _viewId;
@end

@implementation PlayerView

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
    NSString *name = [NSString stringWithFormat:@"com.pulin.aliyun_live/ali_player_%lld", self._viewId];
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:name binaryMessenger:self._messenger];

    [channel setMethodCallHandler:^(FlutterMethodCall *_Nonnull call, FlutterResult _Nonnull result) {
        NSString *method = call.method;
        NSLog(@"接收到数据：%@", method);
        if ([@"startPlay" isEqualToString:method]) {
            // 开始拉流
            self.playurl = call.arguments;
            AVPUrlSource *source = [[AVPUrlSource alloc] urlWithString:self.playurl];
            [self.player setUrlSource:source];
            [self.player prepare];

            result(@"播放成功");
            return;
        }
        if ([@"stopPlay" isEqualToString:method]) {
            // 暂停拉流
            [self.player pause];
            result(@"暂停成功");
            return;
        }
        if ([@"playAgain" isEqualToString:method]) {
            // 重新拉流
            [self.player stop];

            self.playurl = call.arguments;
            AVPUrlSource *source = [[AVPUrlSource alloc] urlWithString:self.playurl];
            [self.player setUrlSource:source];
            [self.player prepare];

            result(@"重新播放成功");
            return;
        }
        if ([@"closePlay" isEqualToString:method]) {
            // 结束拉流
            if (self.player.rate > 0) {
                [self.player stop];
            }
            [self.player destroy];
            result(@"关闭成功");
            return;
        }
    }];
}

- (void)createView {
    self.player = [[AliPlayer alloc] init];
    self.player.autoPlay = YES;
    self.player.playerView = self.renderView;
}

- (nonnull UIView *)view {
    return self.renderView;
}

@end
