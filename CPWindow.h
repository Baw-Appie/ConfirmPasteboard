@import UIKit;

@interface CPWindow : UIWindow
@property (nonatomic) BOOL touchInjection;
+ (instancetype)sharedInstance;
- (id)init;
@end