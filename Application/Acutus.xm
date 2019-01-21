#import "Acutus.h"

// default assigned variables for tweak settings
NSData *spaceImageData = [NSData dataWithContentsOfFile:@"/Library/PreferenceBundles/AcutusPrefs.bundle/spaceImage.png"];
UIImage *image_Space = [UIImage imageWithData: spaceImageData];

static UIWindow *converganceCompatible;
static BOOL MainEnabled = YES;
static BOOL DimFunctionEnabled = YES;
static BOOL themeView = NO;
static CGFloat alphaMain = 1.00;
static int mainColor;
static int mainThemeView;

// loads the preference for the tweak
static void loadPrefs() {
  NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.orangebananaspy.AcutusPrefs.plist"];
  if(prefs) {
    MainEnabled = ( [prefs objectForKey:@"MainEnabled"] ? [[prefs objectForKey:@"MainEnabled"] boolValue] : MainEnabled );
    DimFunctionEnabled = ( [prefs objectForKey:@"DimFunctionEnabled"] ? [[prefs objectForKey:@"DimFunctionEnabled"] boolValue] : DimFunctionEnabled );

    themeView = ( [prefs objectForKey:@"themeView"] ? [[prefs objectForKey:@"themeView"] boolValue] : themeView );
    mainThemeView = ( [prefs objectForKey:@"mainThemeView"] ? [[prefs objectForKey:@"mainThemeView"] intValue] : 1 );

    alphaMain = ( [prefs objectForKey:@"alphaMain"] ? [[prefs objectForKey:@"alphaMain"] floatValue] : alphaMain );
    mainColor = ( [prefs objectForKey:@"mainColor"] ? [[prefs objectForKey:@"mainColor"] intValue] : 15 );
  }
}

// tweak constructor
%ctor {
  // register a settings changed observer which calls loadPrefs() on change
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.orangebananaspy.AcutusPrefs/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
  loadPrefs();
}

// global function to get the UDID of the device
NSString* getUDID() {
  NSString *udid = (__bridge NSString*)MGCopyAnswer(CFSTR("UniqueDeviceID"));
  return udid;
}

%hook SBLockScreenViewController
- (BOOL)isLockScreenVisible {
  // show an alert to the new user
  if (![@"3" isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"FirstAcutusUser"]]) {
    [[NSUserDefaults standardUserDefaults] setValue:@"3" forKey:@"FirstAcutusUser"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    newUser = [[UIAlertView alloc]
    initWithTitle:@"Welcome Acutus User Please Read Carefully!"
    message:@"Thank you for you support! You have successfully installed Acutus 1.1"
    delegate:nil cancelButtonTitle:@"OKAY" otherButtonTitles:nil];
    [newUser show];
  }

  return %orig;
}

/**
A function should never be allowed to be as big as this one, it should always
or most of the time be split into smaller parts as it creates less confusing algorithms and functions
to visualize and debug. Also a very bad practice is shown here when all the variables are reallocated
whenever this function is ran, this should happen in the constructor and this function should only do
the job of showing the allocated views, this wastes many resources.
- Note from future self
**/
- (BOOL)handleMenuButtonDoubleTap {
  if(MainEnabled == YES) {
    // create the main view window
    converganceCompatible = [[UIWindow alloc] initWithFrame:CGRectMake(10, 156, 300, 50)];
    converganceCompatible.windowLevel = [[UIApplication sharedApplication] keyWindow].windowLevel + 1066;
    NSInteger aRedValue = arc4random() % 255;
    NSInteger aGreenValue = arc4random() % 255;
    NSInteger aBlueValue = arc4random() % 255;

    if(themeView == YES) {
      switch (mainThemeView) {
        case 0:
        converganceCompatible.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithData: spaceImageData]];
        break;
        case 1:
        converganceCompatible.backgroundColor = [UIColor clearColor];
        break;
        default:
        converganceCompatible.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithData: spaceImageData]];
        break;
      }
    } else {
      switch (mainColor) {
        case 0:
        converganceCompatible.backgroundColor = [UIColor clearColor];
        break;
        case 1:
        converganceCompatible.backgroundColor = [UIColor brownColor];
        break;
        case 2:
        converganceCompatible.backgroundColor = [UIColor purpleColor];
        break;
        case 3:
        converganceCompatible.backgroundColor = [UIColor orangeColor];
        break;
        case 4:
        converganceCompatible.backgroundColor = [UIColor magentaColor];
        break;
        case 5:
        converganceCompatible.backgroundColor = [UIColor yellowColor];
        break;
        case 6:
        converganceCompatible.backgroundColor = [UIColor cyanColor];
        break;
        case 7:
        converganceCompatible.backgroundColor = [UIColor blueColor];
        break;
        case 8:
        converganceCompatible.backgroundColor = [UIColor greenColor];
        break;
        case 9:
        converganceCompatible.backgroundColor = [UIColor redColor];
        break;
        case 10:
        converganceCompatible.backgroundColor = [UIColor grayColor];
        break;
        case 11:
        converganceCompatible.backgroundColor = [UIColor whiteColor];
        break;
        case 12:
        converganceCompatible.backgroundColor = [UIColor lightGrayColor];
        break;
        case 13:
        converganceCompatible.backgroundColor = [UIColor darkGrayColor];
        break;
        case 14:
        converganceCompatible.backgroundColor = [UIColor blackColor];
        break;
        case 15:
        converganceCompatible.backgroundColor = [UIColor colorWithRed:aRedValue/255.0f green:aGreenValue/255.0f blue:aBlueValue/255.0f alpha:1.0f];
        break;
        default:
        converganceCompatible.backgroundColor = [UIColor clearColor];
        break;
      }
    }
    // show the created window
    [converganceCompatible makeKeyAndVisible];

    // create a root viewcontroller for the window
    UIViewController *vct = [[UIViewController alloc] init];
    converganceCompatible.rootViewController = vct;
    converganceCompatible.hidden = YES;

    // create the custom layer for the root viewcontroller
    CALayer *converganceCompatibleLayer = [converganceCompatible layer];
    [converganceCompatibleLayer setMasksToBounds:YES];
    [converganceCompatibleLayer setCornerRadius:9.0f];
    [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(showView) userInfo:nil repeats:NO];
    [mainView removeFromSuperview];

    // create the main bar with options
    mainView = [[UINavigationBar alloc] init];
    mainView.frame = CGRectMake(0, 0, 300, 50);
    mainView.barStyle = UIBarStyleBlackTranslucent;
    CALayer *mainViewLayer = [mainView layer];
    [mainViewLayer setMasksToBounds:YES];
    [mainViewLayer setCornerRadius:9.0f];
    [converganceCompatible addSubview:mainView];

    // add scrolling to the bar (used to scroll through the options)
    CGRect scrollViewFrame = CGRectMake(0, 0, CGRectGetWidth(mainView.bounds), CGRectGetHeight(mainView.bounds));
    scrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
    [scrollView setContentOffset:CGPointMake(300, 50)];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [mainView  addSubview:scrollView];
    CGSize scrollViewContentSize = CGSizeMake(300, 250);
    [scrollView setContentSize:scrollViewContentSize];
    [scrollView setPagingEnabled:YES];

    // first page
    secondaryView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, CGRectGetWidth(mainView.bounds), CGRectGetHeight(mainView.bounds))];
    secondaryView.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:secondaryView];
    mainView.alpha = 0.0f;

    // the google button
    googleView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [googleView setTitle:@"Google" forState:UIControlStateNormal];
    googleView.frame = CGRectMake(25, 5, 80, 40);
    googleView.layer.borderWidth=1.0f;
    googleView.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    [googleView addTarget:self action:@selector(showGoogleWebView) forControlEvents:UIControlEventTouchUpInside];
    [googleView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [googleView setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    googleViewLayer = [googleView layer];
    googleViewLayer.backgroundColor = [[UIColor clearColor] CGColor];
    [googleViewLayer setMasksToBounds:YES];
    [googleViewLayer setCornerRadius:20.0f];
    [secondaryView addSubview:googleView];

    // the youtube button
    youtubeView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [youtubeView setTitle:@"YouTube" forState:UIControlStateNormal];
    youtubeView.frame = CGRectMake(110, 5, 80, 40);
    youtubeView.layer.borderWidth=1.0f;
    youtubeView.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    [youtubeView addTarget:self action:@selector(showYoutubeWebView) forControlEvents:UIControlEventTouchUpInside];
    [youtubeView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [youtubeView setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    youtubeViewLayer = [youtubeView layer];
    youtubeViewLayer.backgroundColor = [[UIColor clearColor] CGColor];
    [youtubeViewLayer setMasksToBounds:YES];
    [youtubeViewLayer setCornerRadius:20.0f];
    [secondaryView addSubview:youtubeView];

    // the dictionary button
    dictionaryView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [dictionaryView setTitle:@"Dictionary" forState:UIControlStateNormal];
    dictionaryView.frame = CGRectMake(195, 5, 80, 40);
    dictionaryView.layer.borderWidth=1.0f;
    dictionaryView.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    [dictionaryView addTarget:self action:@selector(showDictionaryWebView) forControlEvents:UIControlEventTouchUpInside];
    [dictionaryView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dictionaryView setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    dictionaryViewLayer = [dictionaryView layer];
    dictionaryViewLayer.backgroundColor = [[UIColor clearColor] CGColor];
    [dictionaryViewLayer setMasksToBounds:YES];
    [dictionaryViewLayer setCornerRadius:20.0f];
    [secondaryView addSubview:dictionaryView];

    // add a background layer to the scrollview
    trioView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(mainView.bounds), CGRectGetHeight(mainView.bounds))];
    trioView.backgroundColor = [UIColor clearColor];
    [mainView addSubview:trioView];

    // return button to the navigation bar with options
    returnViews = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [returnViews setTitle:@"Return" forState:UIControlStateNormal];
    returnViews.frame = CGRectMake(25, 5, 80, 40);
    returnViews.layer.borderWidth=1.0f;
    returnViews.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    [returnViews addTarget:self action:@selector(handleMenuButtonDoubleTap) forControlEvents:UIControlEventTouchUpInside];
    [returnViews setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [returnViews setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    returnViewsLayer = [returnViews layer];
    returnViewsLayer.backgroundColor = [[UIColor clearColor] CGColor];
    [returnViewsLayer setMasksToBounds:YES];
    [returnViewsLayer setCornerRadius:20.0f];
    [trioView addSubview:returnViews];
    trioView.alpha = 0.0f;

    // copyright label
    copyRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,200,300,50)];
    copyRightLabel.text = @"©2014 Orangebananaspy";
    copyRightLabel.backgroundColor = [UIColor clearColor];
    copyRightLabel.textColor = [UIColor darkGrayColor];
    copyRightLabel.textAlignment = NSTextAlignmentCenter;
    [copyRightLabel setFont:[UIFont systemFontOfSize:10.0f]];
    [scrollView addSubview:copyRightLabel];

    // another page to the scrollview
    tetraView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, CGRectGetWidth(mainView.bounds), CGRectGetHeight(mainView.bounds))];
    tetraView.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:tetraView];

    // facebook button
    facebookView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [facebookView setTitle:@"Facebook" forState:UIControlStateNormal];
    facebookView.frame = CGRectMake(25, 5, 80, 40);
    facebookView.layer.borderWidth=1.0f;
    facebookView.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    [facebookView addTarget:self action:@selector(showFacebookWebView) forControlEvents:UIControlEventTouchUpInside];
    [facebookView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [facebookView setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    facebookViewLayer = [facebookView layer];
    facebookViewLayer.backgroundColor = [[UIColor clearColor] CGColor];
    [facebookViewLayer setMasksToBounds:YES];
    [facebookViewLayer setCornerRadius:20.0f];
    [tetraView addSubview:facebookView];

    // twitter button
    twitterView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [twitterView setTitle:@"Twitter" forState:UIControlStateNormal];
    twitterView.frame = CGRectMake(110, 5, 80, 40);
    twitterView.layer.borderWidth=1.0f;
    twitterView.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    [twitterView addTarget:self action:@selector(showTwitterWebView) forControlEvents:UIControlEventTouchUpInside];
    [twitterView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [twitterView setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    twitterViewLayer = [twitterView layer];
    twitterViewLayer.backgroundColor = [[UIColor clearColor] CGColor];
    [twitterViewLayer setMasksToBounds:YES];
    [twitterViewLayer setCornerRadius:20.0f];
    [tetraView addSubview:twitterView];

    // instagram button
    instagramView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [instagramView setTitle:@"Instagram" forState:UIControlStateNormal];
    instagramView.frame = CGRectMake(195, 5, 80, 40);
    instagramView.layer.borderWidth=1.0f;
    instagramView.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    [instagramView addTarget:self action:@selector(showInstagramWebView) forControlEvents:UIControlEventTouchUpInside];
    [instagramView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [instagramView setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    instagramViewLayer = [instagramView layer];
    instagramViewLayer.backgroundColor = [[UIColor clearColor] CGColor];
    [instagramViewLayer setMasksToBounds:YES];
    [instagramViewLayer setCornerRadius:20.0f];
    [tetraView addSubview:instagramView];

    // another page to the scrollview
    pentaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(mainView.bounds), CGRectGetHeight(mainView.bounds))];
    pentaView.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:pentaView];

    // brower button
    goBrowser = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [goBrowser setTitle:@"Go" forState:UIControlStateNormal];
    goBrowser.frame = CGRectMake(225, 5, 50, 40);
    goBrowser.layer.borderWidth=1.0f;
    goBrowser.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    [goBrowser addTarget:self action:@selector(showBrowser) forControlEvents:UIControlEventTouchUpInside];
    [goBrowser setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [goBrowser setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    goBrowserLayer = [goBrowser layer];
    goBrowserLayer.backgroundColor = [[UIColor clearColor] CGColor];
    [goBrowserLayer setMasksToBounds:YES];
    [goBrowserLayer setCornerRadius:20.0f];
    [pentaView addSubview:goBrowser];

    // browser searchbar
    browsertextField = [[UITextField alloc] initWithFrame: CGRectMake(25, 5, 198, 40)];
    [browsertextField setBackgroundColor:[UIColor colorWithRed:45.0f green:45.0f blue:45.0f alpha:0.4f]];
    browsertextField.placeholder = @"Enter an address";
    [browsertextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    browsertextFieldLayer = [browsertextField layer];
    browsertextFieldLayer.backgroundColor = [[UIColor clearColor] CGColor];
    [browsertextFieldLayer setMasksToBounds:YES];
    [browsertextFieldLayer setCornerRadius:20.0f];
    [pentaView addSubview:browsertextField];

    // another page to the scrollview
    hexaView = [[UIView alloc] initWithFrame:CGRectMake(0, 150, CGRectGetWidth(mainView.bounds), CGRectGetHeight(mainView.bounds))];
    hexaView.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:hexaView];

    // respring device button
    respringDevice = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [respringDevice setTitle:@"Respring" forState:UIControlStateNormal];
    respringDevice.frame = CGRectMake(25, 5, 80, 40);
    respringDevice.layer.borderWidth=1.0f;
    respringDevice.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    [respringDevice addTarget:self action:@selector(respringUDID) forControlEvents:UIControlEventTouchUpInside];
    [respringDevice setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [respringDevice setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    respringDeviceLayer = [respringDevice layer];
    respringDeviceLayer.backgroundColor = [[UIColor clearColor] CGColor];
    [respringDeviceLayer setMasksToBounds:YES];
    [respringDeviceLayer setCornerRadius:20.0f];
    [hexaView addSubview:respringDevice];

    // reboot device button
    rebootDevice = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [rebootDevice setTitle:@"Reboot" forState:UIControlStateNormal];
    rebootDevice.frame = CGRectMake(110, 5, 80, 40);
    rebootDevice.layer.borderWidth=1.0f;
    rebootDevice.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    [rebootDevice addTarget:self action:@selector(rebootUDID) forControlEvents:UIControlEventTouchUpInside];
    [rebootDevice setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rebootDevice setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    rebootDeviceLayer = [rebootDevice layer];
    rebootDeviceLayer.backgroundColor = [[UIColor clearColor] CGColor];
    [rebootDeviceLayer setMasksToBounds:YES];
    [rebootDeviceLayer setCornerRadius:20.0f];
    [hexaView addSubview:rebootDevice];

    // get into safemode button
    safemodeDevice = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [safemodeDevice setTitle:@"SafeMode" forState:UIControlStateNormal];
    safemodeDevice.frame = CGRectMake(195, 5, 80, 40);
    safemodeDevice.layer.borderWidth=1.0f;
    safemodeDevice.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    [safemodeDevice addTarget:self action:@selector(safemodeUDID) forControlEvents:UIControlEventTouchUpInside];
    [safemodeDevice setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [safemodeDevice setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    safemodeDeviceLayer = [safemodeDevice layer];
    safemodeDeviceLayer.backgroundColor = [[UIColor clearColor] CGColor];
    [safemodeDeviceLayer setMasksToBounds:YES];
    [safemodeDeviceLayer setCornerRadius:20.0f];
    [hexaView addSubview:safemodeDevice];

    // the first stage of security check, it checks for the acutus postinst file
    securityCheck1 = @"/var/lib/dpkg/info/org.thebigboss.acutus.postinst";
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:securityCheck1];
    if (fileExists) {
      // remove extra files as we will re-add them after check
      system("rm -rf /var/mobile/Library/poppy.txt");
      system("rm -rf /var/mobile/Library/pop.txt");
      // if the postinst file exists then create two text files named poppy and pop
      system("if [ -s '/var/lib/dpkg/info/org.thebigboss.acutus.postinst' ];\n then\n echo 'File Is Good'>/var/mobile/Library/pop.txt\n else\n echo 'File Is Good'>/var/mobile/Library/poppy.txt\n fi");

      // run another stage of check
      [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(stillGoing) userInfo:nil repeats:NO];
    } else {
      // if file doesn't exist we assume the tweak has been cracked and let the user know
      Cracked1 = [[UIAlertView alloc]
      initWithTitle:@"Tweak has been cracked"
      message:@"Please be aware of that the tweak may not be operable until it is installed from a legitmate source"
      delegate:nil
      cancelButtonTitle:@"OK"
      otherButtonTitles:nil];
      [Cracked1 show];

      // this will throw device in safemode as the function "jokes" has not been defined on purpose
      [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(jokes) userInfo:nil repeats:NO];
    }

    // the postinst file should never be present in the preference folder of Acutus
    // it was cracked in previous versions and put into that folder to bypass DRM
    securityCheck15 = @"/Library/PreferenceBundles/AcutusPrefs.bundle/postinst";
    BOOL fileExists1 = [[NSFileManager defaultManager] fileExistsAtPath:securityCheck15];
    if (fileExists1) {
      // put device into safemode
      [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(jokes) userInfo:nil repeats:NO];
    }

    return %orig;
  } else {
    return %orig;
  }
}

- (void)finishUIUnlockFromSource:(int)arg1{
  if(MainEnabled == YES) {
    // show the window
    converganceCompatible.hidden = YES;
    showconverganceCompatible = [CATransition animation];
    showconverganceCompatible.delegate = self;
    showconverganceCompatible.duration = 0.2f;
    showconverganceCompatible.fillMode = kCAFillModeForwards;
    showconverganceCompatible.removedOnCompletion = YES;
    showconverganceCompatible.type = kCATransitionPush;
    showconverganceCompatible.subtype = kCATransitionFromLeft;
    [converganceCompatible.layer addAnimation:showconverganceCompatible forKey:@"showconverganceCompatible"];
    %orig;
  } else {
    %orig;
  }
}

- (BOOL)handleMenuButtonTap{
  if(MainEnabled == YES) {
    // animate the bar in when double tap is invoked
    converganceCompatible.hidden = YES;
    showconverganceCompatible = [CATransition animation];
    showconverganceCompatible.delegate = self;
    showconverganceCompatible.duration = 0.2f;
    showconverganceCompatible.fillMode = kCAFillModeForwards;
    showconverganceCompatible.removedOnCompletion = YES;
    showconverganceCompatible.type = kCATransitionPush;
    showconverganceCompatible.subtype = kCATransitionFromLeft;
    [converganceCompatible.layer addAnimation:showconverganceCompatible forKey:@"showconverganceCompatible"];
    return %orig;
  }else{
    return %orig;
  }
}

// extra tools to help with respring, reboot, and safemode
%new
- (void)respringUDID {
  system("./Library/PreferenceBundles/AcutusPrefs.bundle/unicorn_");
}

%new
- (void)rebootUDID{
  system("./Library/PreferenceBundles/AcutusPrefs.bundle/unicorn_pon");
}

%new
- (void)safemodeUDID{
  system("./Library/PreferenceBundles/AcutusPrefs.bundle/unicorn_dos");
}

// second security check
%new
- (void)stillGoing{
  securityCheck2 = @"/var/mobile/Library/poppy.txt";
  BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:securityCheck2];
  if (fileExists) {
    Cracked2 = [[UIAlertView alloc]
    initWithTitle:@"Tweak has been cracked"
    message:@"Please be aware of that the tweak may not be operable until it is installed from a legitmate source"
    delegate:nil
    cancelButtonTitle:@"OK"
    otherButtonTitles:nil];
    [Cracked2 show];

    [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(jokes) userInfo:nil repeats:NO];
  }
}

%new
- (void)showView {
  converganceCompatible.hidden = NO;
  showconverganceCompatible = [CATransition animation];
  showconverganceCompatible.delegate = self;
  showconverganceCompatible.duration = 1.0f;
  showconverganceCompatible.fillMode = kCAFillModeForwards;
  showconverganceCompatible.removedOnCompletion = NO;
  showconverganceCompatible.type = kCATransitionPush;
  showconverganceCompatible.subtype = kCATransitionFromRight;
  [converganceCompatible.layer addAnimation:showconverganceCompatible forKey:@"showconverganceCompatible"];
  mainView.alpha = alphaMain;
  Reachability *checkConnectionStatus = [Reachability reachabilityWithHostName:@"google.com"];
  NetworkStatus internetStatus = [checkConnectionStatus currentReachabilityStatus];
  if(internetStatus == NotReachable) {
    noConnectionAlertView = [[UIAlertView alloc]
    initWithTitle:@"No internet connection"
    message:@"No pages will be loaded due to no internet connection"
    delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [noConnectionAlertView show];
  } else {
    fileManager = [NSFileManager defaultManager];
    NSError *error;
    paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    if (![fileManager fileExistsAtPath:documentsDirectory]) {
      [fileManager createDirectoryAtPath:documentsDirectory withIntermediateDirectories:NO attributes:nil error:&error];
    }
    filePath = [documentsDirectory stringByAppendingPathComponent:@"acutus.txt"];
    [getUDID() writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    system("./Library/PreferenceBundles/AcutusPrefs.bundle/unicorn");
    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(acutus) userInfo:nil repeats:NO];
  }
}

%new
- (void)acutus {
  securityCheck10 = @"/var/mobile/Library/notgoodhappy";
  BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:securityCheck10];
  if (fileExists) {
    Cracked10 = [[UIAlertView alloc]
    initWithTitle:@"Tweak has been cracked"
    message:@"Please be aware of that the tweak may not be operable until it is installed from a legitmate source"
    delegate:nil
    cancelButtonTitle:@"OK"
    otherButtonTitles:nil];
    [Cracked10 show];
    system("rm -rf /var/mobile/Library/notgoodhappy");
    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(jokes) userInfo:nil repeats:NO];
  } else {
    system("rm -rf /var/mobile/Library/goodhappy");
  }
}

%new
- (void)showGoogleWebView {
  showGoogle = [[UIWebView alloc] initWithFrame:CGRectMake(2, 52, 296, 306)];
  showGoogle.scalesPageToFit = YES;
  [showGoogle setBackgroundColor:[UIColor clearColor]];
  showGoogle.scrollView.bounces = NO;
  [showGoogle setOpaque:NO];
  [showGoogle loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://google.com"]]];
  showGoogleLayer = [showGoogle layer];
  showGoogleLayer.backgroundColor = [[UIColor clearColor] CGColor];
  [showGoogleLayer setMasksToBounds:YES];
  [showGoogleLayer setCornerRadius:20.0f];
  [mainView addSubview:showGoogle];
  showGoogle.alpha = 0.0f;
  CGRect mainChange4Google = mainView.frame;
  mainChange4Google.size.height += 310;
  CGRect mainChange4Google2 = converganceCompatible.frame;
  mainChange4Google2.size.height += 310;
  [UIView animateWithDuration:1.0f animations:^{
    mainView.frame = mainChange4Google;
    converganceCompatible.frame = mainChange4Google2;
    secondaryView.alpha = 0.0f;
    showGoogle.alpha = 1.0f;
    trioView.alpha = 1.0f;
    tetraView.alpha = 0.0f;
    pentaView.alpha = 0.0f;
  }];
}

%new
- (void)showYoutubeWebView {
  hideYouTubeView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [hideYouTubeView setTitle:@"Hide" forState:UIControlStateNormal];
  hideYouTubeView.frame = CGRectMake(110, 5, 80, 40);
  hideYouTubeView.layer.borderWidth=1.0f;
  hideYouTubeView.layer.borderColor=[[UIColor lightGrayColor] CGColor];
  [hideYouTubeView addTarget:self action:@selector(hideYoutubeView) forControlEvents:UIControlEventTouchUpInside];
  [hideYouTubeView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [hideYouTubeView setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
  hideYouTubeViewLayer = [hideYouTubeView layer];
  hideYouTubeViewLayer.backgroundColor = [[UIColor clearColor] CGColor];
  [hideYouTubeViewLayer setMasksToBounds:YES];
  [hideYouTubeViewLayer setCornerRadius:20.0f];
  [trioView addSubview:hideYouTubeView];
  showYoutube = [[UIWebView alloc] initWithFrame:CGRectMake(2, 52, 296, 306)];
  showYoutube.scalesPageToFit = YES;
  [showYoutube setBackgroundColor:[UIColor clearColor]];
  showYoutube.scrollView.bounces = NO;
  [showYoutube setOpaque:NO];
  [showYoutube loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://youtube.com"]]];
  showYoutubeLayer = [showYoutube layer];
  showYoutubeLayer.backgroundColor = [[UIColor clearColor] CGColor];
  [showYoutubeLayer setMasksToBounds:YES];
  [showYoutubeLayer setCornerRadius:20.0f];
  [mainView addSubview:showYoutube];
  showYoutube.alpha = 0.0f;
  CGRect mainChange4Youtube = mainView.frame;
  mainChange4Youtube.size.height += 310;
  CGRect mainChange4Youtube2 = converganceCompatible.frame;
  mainChange4Youtube2.size.height += 310;
  [UIView animateWithDuration:1.0f animations:^{
    mainView.frame = mainChange4Youtube;
    converganceCompatible.frame = mainChange4Youtube2;
    secondaryView.alpha = 0.0f;
    showYoutube.alpha = 1.0f;
    trioView.alpha = 1.0f;
    tetraView.alpha = 0.0f;
    pentaView.alpha = 0.0f;
  }];
}

%new
- (void)hideYoutubeView {
  CGRect mainChange4Youtube4 = converganceCompatible.frame;
  mainChange4Youtube4.size.height = 568;
  [UIView animateWithDuration:1.0f animations:^{
    converganceCompatible.frame = mainChange4Youtube4;
  }];
  mainView.alpha = 0.0f;
}

%new
- (void)showDictionaryWebView {
  showDictionary = [[UIWebView alloc] initWithFrame:CGRectMake(2, 52, 296, 306)];
  showDictionary.scalesPageToFit = YES;
  [showDictionary setBackgroundColor:[UIColor colorWithRed:45.0f green:45.0f blue:45.0f alpha:0.2f]];
  showDictionary.scrollView.bounces = NO;
  [showDictionary setOpaque:NO];
  [showDictionary loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://dictionary.com"]]];
  showDictionaryLayer = [showDictionary layer];
  showDictionaryLayer.backgroundColor = [[UIColor colorWithRed:45.0f green:45.0f blue:45.0f alpha:0.2f] CGColor];
  [showDictionaryLayer setMasksToBounds:YES];
  [showDictionaryLayer setCornerRadius:20.0f];
  [mainView addSubview:showDictionary];
  showDictionary.alpha = 0.0f;
  CGRect mainChange4Dictionary = mainView.frame;
  mainChange4Dictionary.size.height += 310;
  CGRect mainChange4Dictionary2 = converganceCompatible.frame;
  mainChange4Dictionary2.size.height += 310;
  [UIView animateWithDuration:1.0f animations:^{
    mainView.frame = mainChange4Dictionary;
    converganceCompatible.frame = mainChange4Dictionary2;
    secondaryView.alpha = 0.0f;
    showDictionary.alpha = 1.0f;
    trioView.alpha = 1.0f;
    tetraView.alpha = 0.0f;
    pentaView.alpha = 0.0f;
  }];
}

%new
- (void)showFacebookWebView {
  showFacebook = [[UIWebView alloc] initWithFrame:CGRectMake(2, 52, 296, 306)];
  showFacebook.scalesPageToFit = YES;
  [showFacebook setBackgroundColor:[UIColor colorWithRed:45.0f green:45.0f blue:45.0f alpha:0.2f]];
  showFacebook.scrollView.bounces = NO;
  [showFacebook setOpaque:NO];
  [showFacebook loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://m.facebook.com"]]];
  showFacebookLayer = [showFacebook layer];
  showFacebookLayer.backgroundColor = [[UIColor colorWithRed:45.0f green:45.0f blue:45.0f alpha:0.2f] CGColor];
  [showFacebookLayer setMasksToBounds:YES];
  [showFacebookLayer setCornerRadius:20.0f];
  [mainView addSubview:showFacebook];
  showFacebook.alpha = 0.0f;
  CGRect mainChange4Facebook = mainView.frame;
  mainChange4Facebook.size.height += 310;
  CGRect mainChange4Facebook2 = converganceCompatible.frame;
  mainChange4Facebook2.size.height += 310;
  [UIView animateWithDuration:1.0f animations:^{
    converganceCompatible.frame = mainChange4Facebook2;
    mainView.frame = mainChange4Facebook;
    secondaryView.alpha = 0.0f;
    showFacebook.alpha = 1.0f;
    trioView.alpha = 1.0f;
    tetraView.alpha = 0.0f;
    pentaView.alpha = 0.0f;
  }];
}

%new
- (void)showTwitterWebView {
  showTwitter = [[UIWebView alloc] initWithFrame:CGRectMake(2, 52, 296, 306)];
  showTwitter.scalesPageToFit = YES;
  [showTwitter setBackgroundColor:[UIColor colorWithRed:45.0f green:45.0f blue:45.0f alpha:0.2f]];
  showTwitter.scrollView.bounces = NO;
  [showTwitter setOpaque:NO];
  [showTwitter loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://mobile.twitter.com"]]];
  showTwitterLayer = [showTwitter layer];
  showTwitterLayer.backgroundColor = [[UIColor colorWithRed:45.0f green:45.0f blue:45.0f alpha:0.2f] CGColor];
  [showTwitterLayer setMasksToBounds:YES];
  [showTwitterLayer setCornerRadius:20.0f];
  [mainView addSubview:showTwitter];
  showTwitter.alpha = 0.0f;
  CGRect mainChange4Twitter = mainView.frame;
  mainChange4Twitter.size.height += 310;
  CGRect mainChange4Twitter2 = converganceCompatible.frame;
  mainChange4Twitter2.size.height += 310;
  [UIView animateWithDuration:1.0f animations:^{
    mainView.frame = mainChange4Twitter;
    converganceCompatible.frame = mainChange4Twitter2;
    secondaryView.alpha = 0.0f;
    showTwitter.alpha = 1.0f;
    trioView.alpha = 1.0f;
    tetraView.alpha = 0.0f;
    pentaView.alpha = 0.0f;
  }];
}

%new
- (void)showInstagramWebView {
  showInstagram = [[UIWebView alloc] initWithFrame:CGRectMake(2, 52, 296, 306)];
  showInstagram.scalesPageToFit = YES;
  [showInstagram setBackgroundColor:[UIColor colorWithRed:45.0f green:45.0f blue:45.0f alpha:0.2f]];
  showInstagram.scrollView.bounces = NO;
  [showInstagram setOpaque:NO];
  [showInstagram loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://instagram.com/accounts/login/"]]];
  showInstagramLayer = [showInstagram layer];
  showInstagramLayer.backgroundColor = [[UIColor colorWithRed:45.0f green:45.0f blue:45.0f alpha:0.2f] CGColor];
  [showInstagramLayer setMasksToBounds:YES];
  [showInstagramLayer setCornerRadius:20.0f];
  [mainView addSubview:showInstagram];
  showInstagram.alpha = 0.0f;
  CGRect mainChange4Instagram = mainView.frame;
  mainChange4Instagram.size.height += 310;
  CGRect mainChange4Instagram2 = converganceCompatible.frame;
  mainChange4Instagram2.size.height += 310;
  [UIView animateWithDuration:1.0f animations:^{
    mainView.frame = mainChange4Instagram;
    converganceCompatible.frame = mainChange4Instagram2;
    secondaryView.alpha = 0.0f;
    showInstagram.alpha = 1.0f;
    trioView.alpha = 1.0f;
    tetraView.alpha = 0.0f;
    pentaView.alpha = 0.0f;
  }];
}

%new
- (void)showBrowser {
  browserView = [[UIWebView alloc] initWithFrame:CGRectMake(2, 52, 296, 306)];
  browserView.scalesPageToFit = YES;
  [browserView setBackgroundColor:[UIColor colorWithRed:45.0f green:45.0f blue:45.0f alpha:0.2f]];
  browserView.scrollView.bounces = NO;
  [browserView setOpaque:NO];
  browserViewLayer = [browserView layer];
  browserViewLayer.backgroundColor = [[UIColor colorWithRed:45.0f green:45.0f blue:45.0f alpha:0.2f] CGColor];
  [browserViewLayer setMasksToBounds:YES];
  [browserViewLayer setCornerRadius:20.0f];
  [mainView addSubview:browserView];
  browserView.alpha = 0.0f;
  CGRect mainChange4Browser = mainView.frame;
  mainChange4Browser.size.height += 310;
  CGRect mainChange4Browser2 = converganceCompatible.frame;
  mainChange4Browser2.size.height += 310;
  [UIView animateWithDuration:1.0f animations:^{
    mainView.frame = mainChange4Browser;
    converganceCompatible.frame = mainChange4Browser2;
    secondaryView.alpha = 0.0f;
    browserView.alpha = 1.0f;
    trioView.alpha = 1.0f;
    tetraView.alpha = 0.0f;
    pentaView.alpha = 0.0f;
  }];
  [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(showBrowserInput) userInfo:nil repeats:NO];
}

%new
- (void)showBrowserInput {
  urlString = browsertextField.text;
  urlString = [@"http://" stringByAppendingString:urlString];
  [browsertextField resignFirstResponder];
  NSURL *url = [NSURL URLWithString:urlString];
  NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
  [browserView loadRequest:requestObj];
}
%end

%hook SBLockScreenViewControllerBase
- (BOOL)wantsScreenToAutoDim {
  if(MainEnabled == YES && DimFunctionEnabled == YES) {
      return nil;
  } else{ 
    return %orig;
  }
}
%end
