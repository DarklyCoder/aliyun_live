#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlayerView : NSObject<FlutterPlatformView>

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger> *_Nonnull)messenger frame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args;
@end

NS_ASSUME_NONNULL_END
