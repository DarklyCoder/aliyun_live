#import "AliyunLivePlugin.h"
#import "PlayerViewFactory.h"
#import "LiveViewFactory.h"
#import "Constants.h"

@implementation AliyunLivePlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    PlayerViewFactory *playerFactory = [[PlayerViewFactory alloc]initWithMessenger:[registrar messenger]];
    [registrar registerViewFactory:playerFactory withId:PLAYER_VIEW_TYPE_ID];

    LiveViewFactory *liveFactory = [[LiveViewFactory alloc]initWithMessenger:[registrar messenger]];
    [registrar registerViewFactory:liveFactory withId:LIVE_VIEW_TYPE_ID];
}

@end
