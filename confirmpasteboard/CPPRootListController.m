#include "CPPRootListController.h"
#import <AppList/AppList.h>

#define PREFERENCE_IDENTIFIER @"/var/mobile/Library/Preferences/com.rpgfarm.confirmpasteboardprefs.plist"

static NSInteger DictionaryTextComparator(id a, id b, void *context) {
	return [[(__bridge NSDictionary *)context objectForKey:a] localizedCaseInsensitiveCompare:[(__bridge NSDictionary *)context objectForKey:b]];
}

NSMutableDictionary *prefs;

@implementation CPPRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		[self getPreference];

		NSMutableArray *specifiers = [[NSMutableArray alloc] init];
		[specifiers addObject:({
			PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"Credits" target:self set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
			specifier;
		})];
		[specifiers addObject:({
			PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"@BawAppie (Developer)" target:self set:nil get:nil detail:nil cell:PSButtonCell edit:nil];
			[specifier setIdentifier:@"BawAppie"];
	    	specifier->action = @selector(openCredits:);
			specifier;
		})];

		[specifiers addObject:[PSSpecifier preferenceSpecifierNamed:@"ConfirmPasteboard" target:self set:nil get:nil detail:nil cell:PSGroupCell edit:nil]];

		[specifiers addObject:({
			PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"Enable" target:self set:@selector(setSwitch:forSpecifier:) get:@selector(getSwitch:) detail:nil cell:PSSwitchCell edit:nil];
			[specifier.properties setValue:@"enable" forKey:@"displayIdentifier"];
			specifier;
		})];

		[specifiers addObject:[PSSpecifier preferenceSpecifierNamed:@"Installed Applications" target:self set:nil get:nil detail:nil cell:PSGroupCell edit:nil]];

		ALApplicationList *applicationList = [ALApplicationList sharedApplicationList];
		NSDictionary *applications = [applicationList applicationsFilteredUsingPredicate:[NSPredicate predicateWithFormat:@"!(bundleIdentifier BEGINSWITH[c] %@)", @"com.apple."]];
		NSMutableArray *displayIdentifiers = [[applications allKeys] mutableCopy];

		[displayIdentifiers sortUsingFunction:DictionaryTextComparator context:(__bridge void *)applications];

		for (NSString *displayIdentifier in displayIdentifiers) {
			PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:applications[displayIdentifier] target:self set:@selector(setSwitch:forSpecifier:) get:@selector(getSwitch:) detail:nil cell:PSSwitchCell edit:nil];
			[specifier.properties setValue:displayIdentifier forKey:@"displayIdentifier"];

			UIImage *icon = [applicationList iconOfSize:ALApplicationIconSizeSmall forDisplayIdentifier:displayIdentifier];
			if (icon) [specifier setProperty:icon forKey:@"iconImage"];

			[specifiers addObject:specifier];
		}


		_specifiers = [specifiers copy];

	}


	return _specifiers;
}

-(void)setSwitch:(NSNumber *)value forSpecifier:(PSSpecifier *)specifier {
	prefs[[specifier propertyForKey:@"displayIdentifier"]] = [NSNumber numberWithBool:[value boolValue]];
	[[prefs copy] writeToFile:PREFERENCE_IDENTIFIER atomically:FALSE];
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.rpgfarm.confirmpasteboard/settingsupdate"), NULL, NULL, true);
	// HBLogDebug(@"setSwitch %@, %@, %@", value, [specifier propertyForKey:@"displayIdentifier"], prefs);
}
-(NSNumber *)getSwitch:(PSSpecifier *)specifier {
	// HBLogDebug(@"getSwitch %@", prefs);
	if(!prefs[[specifier propertyForKey:@"displayIdentifier"]] && [[specifier propertyForKey:@"displayIdentifier"] isEqualToString:@"enable"]) return @1;
	return [prefs[[specifier propertyForKey:@"displayIdentifier"]] isEqual:@1] ? @1 : @0;
}

-(void)getPreference {
	if(![[NSFileManager defaultManager] fileExistsAtPath:PREFERENCE_IDENTIFIER]) prefs = [[NSMutableDictionary alloc] init];
	else prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:PREFERENCE_IDENTIFIER];
}


@end
