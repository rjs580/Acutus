//
//  AcutusPrefsListController.m
//  AcutusPrefs
//
//  Created by Orangebananaspy on 11.05.2014.
//  Copyright (c) 2014 Orangebananaspy. All rights reserved.
//

#import "AcutusPrefsListController.h"
#import "AcutusPrefs2ListController.h"

@implementation AcutusPrefsListController

- (id)specifiers {
	if (_specifiers == nil) {
		_specifiers = [self loadSpecifiersFromPlistName:@"AcutusPrefs" target:self];
	}
	
	return _specifiers;
}
- (void)followOnTwitter {
	if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"tweetbot:"]]) {
		[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tweetbot:///user_profile/orangebananaspy"]];
	} else if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"tweetings:"]]) {
		[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tweetings:///user?screen_name=orangebananaspy"]];
	} else if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"twitter:"]]) {
		[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"twitter://user?screen_name=orangebananaspy"]];
	} else {
		[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://twitter.com/intent/follow?screen_name=orangebananaspy"]];
	}
}
@end

@implementation AcutusPrefs2ListController

- (id)specifiers {
	if (_specifiers == nil) {
		_specifiers = [self loadSpecifiersFromPlistName:@"AcutusPrefs2" target:self];
	}
    
	return _specifiers;
}
@end