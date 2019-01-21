#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>
#import "Reachability.h"

// definition from MobileGestalt - used to get device UDID
OBJC_EXTERN CFStringRef MGCopyAnswer(CFStringRef key) WEAK_IMPORT_ATTRIBUTE;

// tweak variables
UINavigationBar *mainView;
UIView *secondaryView;
CATransition *showMainView;
CATransition *hideMainView;
CATransition *hideMainView2;
UIButton *googleView;
CALayer *googleViewLayer;
UIWebView *showGoogle;
CALayer *showGoogleLayer;
UIView *trioView;
UIButton *returnViews;
CALayer *returnViewsLayer;
UIButton *youtubeView;
CALayer *youtubeViewLayer;
UIWebView *showYoutube;
CALayer *showYoutubeLayer;
UIButton *dictionaryView;
CALayer *dictionaryViewLayer;
UIWebView *showDictionary;
CALayer *showDictionaryLayer;
UIScrollView *scrollView;
UILabel *copyRightLabel;
UIAlertView *noConnectionAlertView;
NSString *securityCheck1;
UIAlertView *Cracked1;
NSString *securityCheck2;
UIAlertView *Cracked2;
UIView *tetraView;
UIButton *facebookView;
CALayer *facebookViewLayer;
UIButton *twitterView;
CALayer *twitterViewLayer;
UIButton *instagramView;
CALayer *instagramViewLayer;
UIWebView *showFacebook;
CALayer *showFacebookLayer;
UIWebView *showInstagram;
CALayer *showInstagramLayer;
UIWebView *showTwitter;
CALayer *showTwitterLayer;
UIAlertView *newUser;
UIView *pentaView;
UIButton *goBrowser;
CALayer *goBrowserLayer;
UITextField *browsertextField;
UIWebView *browserView;
CALayer *browserViewLayer;
NSString *urlString;
CALayer *browsertextFieldLayer;
NSFileManager *fileManager;
NSString *securityCheck10;
UIAlertView *Cracked10;
NSArray *paths;
NSString *filePath;
CATransition *showconverganceCompatible;
NSString *securityCheck15;

UIView *hexaView;
UIButton *respringDevice;
CALayer *respringDeviceLayer;
UIButton *rebootDevice;
CALayer *rebootDeviceLayer;
UIButton *safemodeDevice;
CALayer *safemodeDeviceLayer;

UIButton *hideYouTubeView;
CALayer *hideYouTubeViewLayer;

/**
  Variables, especially similar ones should most definetly be grouped and organized within a custom
  class to be used repeatedly rather than individual loose definitions as shown above.
  - Note from future self
**/
