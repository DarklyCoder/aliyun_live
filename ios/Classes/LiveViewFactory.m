#import "LiveViewFactory.h"
#import "LiveView.h"

@interface LiveViewFactory ()
@property (nonatomic) NSObject<FlutterBinaryMessenger> *_messenger;
@end

@implementation LiveViewFactory

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger> *)messenger {
    self = [super init];
    if (self) {
        self._messenger = messenger;
    }
    return self;
}

- (NSObject<FlutterMessageCodec> *)createArgsCodec{
    return [FlutterStandardMessageCodec sharedInstance];
}

- (nonnull NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args {
 
    return  [[ LiveView alloc]initWithMessenger:self._messenger frame:frame viewIdentifier:viewId arguments:args];
}

@end
