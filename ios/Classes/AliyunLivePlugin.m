#import "AliyunLivePlugin.h"
#import "PlayerViewFactory.h"
#import "LiveViewFactory.h"

@implementation AliyunLivePlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    PlayerViewFactory *playerFactory = [[PlayerViewFactory alloc]initWithMessenger:[registrar messenger]];
    [registrar registerViewFactory:playerFactory withId:@"com.pulin.aliyun_live/AliPlayerView"];

    LiveViewFactory *liveFactory = [[LiveViewFactory alloc]initWithMessenger:[registrar messenger]];
    [registrar registerViewFactory:liveFactory withId:@"com.pulin.aliyun_live/AliLiveView"];
}

@end
