#import <MRYIPCCenter.h>
#import "CPWindow.h"
#import "CPViewController.h"


%group hooker

BOOL isAllowed;
BOOL isRequested;

dispatch_semaphore_t sema;

extern CFNotificationCenterRef CFNotificationCenterGetDistributedCenter(void);

void updateStatus() {
	if(isRequested) return;
	isRequested = true;

	sema = dispatch_semaphore_create(0);

    NSDictionary *info = @{
    	@"bundleID": [NSBundle mainBundle].bundleIdentifier
    };
    CFNotificationCenterPostNotification(CFNotificationCenterGetDistributedCenter(), (__bridge CFStringRef)@"com.rpgfarm.confirmpasteboard.accessRequest", NULL, (__bridge CFDictionaryRef)info, YES);   

	[[%c(NSDistributedNotificationCenter) defaultCenter] addObserverForName:[NSString stringWithFormat:@"com.rpgfarm.confirmpasteboard.%@.accessResult", [NSBundle mainBundle].bundleIdentifier] object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
		NSDictionary *result = notification.userInfo;
		isAllowed = [result[@"allowed"] isEqual:@1];
		dispatch_semaphore_signal(sema);
	}];

    if (![NSThread isMainThread]) {
	    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
	} else {
	    while (dispatch_semaphore_wait(sema, DISPATCH_TIME_NOW)) { 
	        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0]]; 
	    }
	}

}

%hook UIPasteboard
- (NSArray *)itemProviders {
	updateStatus();
	if (!isAllowed) {
		return nil;
	} else {
		return %orig;
	}
}
- (_Bool)hasColors {
	updateStatus();
	if (!isAllowed) {
		return NO;
	} else {
		return %orig;
	}
}
- (_Bool)hasImages{
	updateStatus();
	if (!isAllowed) {
		return NO;
	} else {
		return %orig;
	}
}
- (_Bool)hasURLs{
	updateStatus();
	if (!isAllowed) {
		return NO;
	} else {
		return %orig;
	}
}
- (_Bool)hasStrings{
	updateStatus();
	if (!isAllowed) {
		return NO;
	} else {
		return %orig;
	}
}
- (NSArray *)colors {
	updateStatus();
	if (!isAllowed) {
		return nil;
	} else {
		return %orig;
	}
}
- (NSArray *)images {
	updateStatus();
	if (!isAllowed) {
		return nil;
	} else {
		return %orig;
	}
}
- (NSArray *)URLs {
	updateStatus();
	if (!isAllowed) {
		return nil;
	} else {
		return %orig;
	}
}
- (NSArray *)strings {
	updateStatus();
	if (!isAllowed) {
		return nil;
	} else {
		return %orig;
	}
}
- (UIColor *)color {
	updateStatus();
	if (!isAllowed) {
		return nil;
	} else {
		return %orig;
	}
}
- (UIImage *)image {
	updateStatus();
	if (!isAllowed) {
		return nil;
	} else {
		return %orig;
	}
}
- (NSURL *)URL {
	updateStatus();
	if (!isAllowed) {
		return nil;
	} else {
		return %orig;
	}
}
- (NSString *)string {
	updateStatus();
	if (!isAllowed) {
		return nil;
	} else {
		return %orig;
	}
}

- (id)dataForPasteboardType:(id)arg1 inItemSet:(id)arg2 {
	updateStatus();
	if (!isAllowed) {
		return nil;
	} else {
		return %orig(arg1, arg2);
	}
}
- (id)dataForPasteboardType:(id)arg1 {
	updateStatus();
	if (!isAllowed) {
		return nil;
	} else {
		return %orig(arg1);
	}
}
%end

%hook _UIConcretePasteboard
- (id)itemProviders {
	updateStatus();
	if (!isAllowed) {
		return nil;
	} else {
		return %orig;
	}
}
- (_Bool)hasColors {
	updateStatus();
	if (!isAllowed) {
		return NO;
	} else {
		return %orig;
	}
}
- (_Bool)hasImages{
	updateStatus();
	if (!isAllowed) {
		return NO;
	} else {
		return %orig;
	}
}
- (_Bool)hasURLs{
	updateStatus();
	if (!isAllowed) {
		return NO;
	} else {
		return %orig;
	}
}
- (_Bool)hasStrings{
	updateStatus();
	if (!isAllowed) {
		return NO;
	} else {
		return %orig;
	}
}
- (id)colors {
	updateStatus();
	if (!isAllowed) {
		return nil;
	} else {
		return %orig;
	}
}
- (id)images {
	updateStatus();
	if (!isAllowed) {
		return nil;
	} else {
		return %orig;
	}
}
- (id)URLs {
	updateStatus();
	if (!isAllowed) {
		return nil;
	} else {
		return %orig;
	}
}
- (id)strings {
	updateStatus();
	if (!isAllowed) {
		return nil;
	} else {
		return %orig;
	}
}
- (id)color {
	updateStatus();
	if (!isAllowed) {
		return nil;
	} else {
		return %orig;
	}
}
- (id)image {
	updateStatus();
	if (!isAllowed) {
		return nil;
	} else {
		return %orig;
	}
}
- (id)URL {
	updateStatus();
	if (!isAllowed) {
		return nil;
	} else {
		return %orig;
	}
}
- (id)string {
	updateStatus();
	if (!isAllowed) {
		return nil;
	} else {
		return %orig;
	}
}
- (id)items {
	updateStatus();
	if (!isAllowed) {
		return nil;
	} else {
		return %orig;
	}
}

- (id)dataForPasteboardType:(id)arg1 inItemSet:(id)arg2 {
	updateStatus();
	if (!isAllowed) {
		return nil;
	} else {
		return %orig(arg1, arg2);
	}
}
- (id)dataForPasteboardType:(id)arg1 {
	updateStatus();
	if (!isAllowed) {
		return nil;
	} else {
		return %orig(arg1);
	}
}
%end


%end

NSMutableDictionary *prefs;

@interface SBApplicationController
+(id)sharedInstance;
-(id)applicationWithBundleIdentifier:(id)arg1 ;
@end

%group SpringBoard
void handleAccessRequest(CFNotificationCenterRef center, void * observer, CFStringRef name, const void * object, CFDictionaryRef userInfo);
%hook SpringBoard
-(void)applicationDidFinishLaunching:(id)application {
  %orig;
  CFNotificationCenterAddObserver(CFNotificationCenterGetDistributedCenter(), NULL, handleAccessRequest, (__bridge CFStringRef)@"com.rpgfarm.confirmpasteboard.accessRequest", NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}

void response(BOOL allowed, NSString *bundleID) {
	[[objc_getClass("NSDistributedNotificationCenter") defaultCenter] postNotificationName:[NSString stringWithFormat:@"com.rpgfarm.confirmpasteboard.%@.accessResult", bundleID] object:nil userInfo:@{
		@"allowed": @(allowed)
	}];
}

#define PREF_PATH @"/var/mobile/Library/Preferences/com.rpgfarm.confirmpasteboardprefs.plist"

void handleAccessRequest(CFNotificationCenterRef center, void * observer, CFStringRef name, const void * object, CFDictionaryRef userInfo) {
    NSDictionary* info = (__bridge NSDictionary*)userInfo;

	CPWindow *window = [CPWindow sharedInstance];
	CPViewController *controller = [CPViewController sharedInstance];

	UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@ wants to access the clipboard.", [[[NSClassFromString(@"SBApplicationController") sharedInstance] applicationWithBundleIdentifier:info[@"bundleID"]] displayName]] message:@"Do you want to allow access to the clipboard?" preferredStyle:UIAlertControllerStyleAlert];
	controller.alert = alert;

	[controller.alert addAction:[UIAlertAction actionWithTitle:@"Allow" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
		window.touchInjection = false;
		prefs[info[@"bundleID"]] = @1;
		[[prefs copy] writeToFile:PREF_PATH atomically:FALSE];
		response(true, info[@"bundleID"]);
	}]];

	[controller.alert addAction:[UIAlertAction actionWithTitle:@"Allow only this time" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
		window.touchInjection = false;
		response(true, info[@"bundleID"]);
	}]];

	[controller.alert addAction:[UIAlertAction actionWithTitle:@"Deny" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
		window.touchInjection = false;
		response(false, info[@"bundleID"]);
	}]];
	
	window.touchInjection = true;
	[controller presentViewController:controller.alert animated:YES completion:nil];
}
%end

%end

void loadPrefs() {
	prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:PREF_PATH];
	if(!prefs) prefs = [@{} mutableCopy];
}

%ctor {
	NSString *identifier = [NSBundle mainBundle].bundleIdentifier;
	if([identifier isEqualToString:@"com.apple.springboard"]) {
		%init(SpringBoard);
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.rpgfarm.confirmpasteboard/settingsupdate"), NULL, CFNotificationSuspensionBehaviorCoalesce);
		loadPrefs();
		return;
	}
	if([identifier hasPrefix:@"com.apple."]) return;

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.rpgfarm.confirmpasteboard/settingsupdate"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	loadPrefs();

	if(prefs[@"enable"] && [prefs[@"enable"] isEqual:@0]) return;
	if(prefs[identifier] && [prefs[identifier] isEqual:@1]) return;
	%init(hooker);
	isAllowed = false;
}