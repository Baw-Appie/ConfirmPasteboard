@import UIKit;

@interface CPViewController : UIViewController
@property (nonatomic, strong) UIAlertController *alert;

+ (instancetype)sharedInstance;

@end