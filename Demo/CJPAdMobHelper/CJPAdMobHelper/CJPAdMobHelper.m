//
//  CJPAdMobHelper.m
//  CJPAdMobHelper
//
//  Created by Chris Phillips on 30/09/2016.
//  Copyright © 2016 Midnight Labs Ltd. All rights reserved.
//

#import "CJPAdMobHelper.h"

// Debug logging
#if defined(DEBUG) && defined(DEBUG_CJPADMOBHELPER)
#define CJPLog(fmt, ...) NSLog((@"%@ [line %u]: " fmt), NSStringFromClass(self.class), __LINE__, ##__VA_ARGS__)
#else
#define CJPLog(...)
#endif

static NSString * const CJPAdsPurchasedKey = @"adRemovalPurchased";

@interface CJPAdMobHelper ()

@property (nonatomic, strong) GADBannerView *adMobView;
@property (nonatomic, strong) UIViewController *contentController;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, assign) BOOL showingAd;
@property (nonatomic, strong) NSDictionary *adMobUserLocation;

- (void)createBanner;
- (void)removeBannerAndPermanently:(BOOL)permanent;
- (void)layoutAds;
- (UIViewController *)currentViewController;

@end

@implementation CJPAdMobHelper

#pragma mark -
#pragma mark Class Methods

+ (CJPAdMobHelper *)sharedInstance
{
    static CJPAdMobHelper *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init
{
    if ((self = [super init]))
    {
        // Have ads been removed?
        _adsRemoved = [[NSUserDefaults standardUserDefaults] boolForKey:CJPAdsPurchasedKey];
        
        // Set defaults
        _initialDelay = 0.0;
        _useAdMobSmartSize = YES;
    }
    return self;
}

- (void)startWithViewController:(UIViewController *)contentController
{
    _contentController = contentController;
    
    // Create a container view to hold our parent view and the banner view
    _containerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self addChildViewController:_contentController];
    [_containerView addSubview:_contentController.view];
    [_contentController didMoveToParentViewController:self];
    
    // Set the container view as this view
    self.view = _containerView;
    
    // Now everything is set up, we can create a banner (if the user hasn't purchased ad removal)
    if (!_adsRemoved) {
        [self performSelector:@selector(createBanner) withObject:nil afterDelay:_initialDelay];
    }
}

#pragma mark -
#pragma mark Banner Create/Destroy

- (void)createBanner
{
    BOOL isPortrait = UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]);
    BOOL isIPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? YES : NO;
    
    // Create AdMob banner
    CJPLog(@"Creating AdMob");
    GADAdSize adMobSize;
    if (_useAdMobSmartSize) {
        adMobSize = isPortrait ? kGADAdSizeSmartBannerPortrait : kGADAdSizeSmartBannerLandscape;
        _adMobView = [[GADBannerView alloc] initWithAdSize:adMobSize];
    }
    else {
        // Legacy AdMob ad sizes don't fill the full width of the device screen apart from iPhone when in portrait view
        // We need to offset the x position so the ad appears centered - Calculation: (View width - Ad width) / 2
        // Problem is that getting the width of the bounds doesn't take into account the current orientation
        // As a workaround, if we're in landscape, we'll simply get the height instead
        CGRect screen = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = isPortrait ? CGRectGetWidth(screen) : CGRectGetHeight(screen);
        adMobSize = isIPad ? kGADAdSizeLeaderboard : kGADAdSizeBanner;
        CGSize cgAdMobSize = CGSizeFromGADAdSize(adMobSize);
        CGFloat adMobXOffset = (screenWidth-cgAdMobSize.width)/2;
        _adMobView = [[GADBannerView alloc] initWithFrame:CGRectMake(adMobXOffset, self.view.frame.size.height - cgAdMobSize.height, cgAdMobSize.width, cgAdMobSize.height)];
    }
    
    // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
    _adMobView.adUnitID = _adMobUnitID;
    
    // Set initial frame to be off screen
    CGRect bannerFrame = _adMobView.frame;
    bannerFrame.origin.y = [[UIScreen mainScreen] bounds].size.height;
    _adMobView.frame = bannerFrame;
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    _adMobView.rootViewController = self;
    _adMobView.delegate = self;
    _adMobView.hidden = YES;
    [_containerView insertSubview:_adMobView atIndex:0];
    
    // Request an ad
    GADRequest *adMobRequest = [GADRequest request];
    
    // Device identifier strings that will receive test AdMob ads
    // This should be the Simulator in addition to any actual device IDs specified 
    NSMutableArray *testDevIDs = [NSMutableArray arrayWithObject:kGADSimulatorID];
    if (_testDeviceIDs!=nil) {
        [testDevIDs addObjectsFromArray:_testDeviceIDs];
    }
    adMobRequest.testDevices = [testDevIDs copy];
    
    /*
     COPPA
     
     If this app has been tagged as being aimed at children (1), or not for children (0), send the value with the ad request
     Ignore if the tag has not been set
     */
    //
    if ([_tagForChildDirectedTreatment isEqualToString:@"0"] || [_tagForChildDirectedTreatment isEqualToString:@"1"]) {
        BOOL tagForCOPPA = [_tagForChildDirectedTreatment isEqualToString:@"1"] ? YES : NO;
        [adMobRequest tagForChildDirectedTreatment:tagForCOPPA];
        CJPLog(@"COPPA has been set to %i", tagForCOPPA);
    }
    
    /*
     Targeting
     
     We only send this information with our request if they have been explicitly set
     */
    
    // Gender
    if (_adMobGender != kGADGenderUnknown) {
        adMobRequest.gender = _adMobGender;
        CJPLog(@"AdMob targeting: Gender has been set to %i", (int)_adMobGender);
    }
    
    // Birthday
    if (_adMobBirthday != nil) {
        adMobRequest.birthday = _adMobBirthday;
        CJPLog(@"AdMob targeting: Birthday has been set.");
    }
    
    // Location
    if (_adMobUserLocation != nil) {
        [adMobRequest setLocationWithLatitude:[[_adMobUserLocation objectForKey:@"latitude"] floatValue] longitude:[[_adMobUserLocation objectForKey:@"longitude"] floatValue] accuracy:[[_adMobUserLocation objectForKey:@"accuracy"] floatValue]];
        CJPLog(@"AdMob targeting: Location has been set to %@", _adMobUserLocation);
    }
    
    // Now we can load the requested ad
    [_adMobView loadRequest:adMobRequest];
    CJPLog(@"Added AdMob to view and requested ad.");
}

- (void)removeBannerAndPermanently:(BOOL)permanent
{
    // When `permanently` is NO
    // This method simply hides the banner from view - the banner will show again when the next ad request is fired...
    // This will be 2 minutes for AdMob (but can be changed in your AdMob account)
    
    // When `permanently` is YES
    // This method will set the banner's view to nil and remove the banner completely from the container view
    // A new banner will not be shown unless you call restartAds.
    
    _showingAd = NO;
    CGRect bannerFrame = _adMobView.frame;
    bannerFrame.origin.y = [[UIScreen mainScreen] bounds].size.height;
    _adMobView.frame = bannerFrame;
    [_containerView sendSubviewToBack:_adMobView];
    if (permanent) {
        _adMobView.delegate = nil;
        [_adMobView removeFromSuperview];
        _adMobView = nil;
        CJPLog(@"Permanently removed AdMob from view.");
    }
    else {
        CJPLog(@"Temporarily hiding AdMob off screen.");
    }

    [UIView animateWithDuration:0.25 animations:^{
        [self layoutAds];
    }];
}

#pragma mark Remove ads from view

- (void)removeAdsAndMakePermanent:(BOOL)permanent andRemember:(BOOL)remember
{
    // Make sure any performSelector requests are canceled...
    // Fixes a bug where if a long initial delay is given, a user could remove ads after the perform request is sent but
    // before the delay ends, leading to ads created when they shouldn't be
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    // Remove ad banner from the view
    if (_adMobView!=nil) [self removeBannerAndPermanently:permanent];
    
    // Set adsRemoved to YES, and store in NSUserDefaults for future reference if remember and permanent both true
    if (permanent && remember) {
        _adsRemoved = YES;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:CJPAdsPurchasedKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)removeAds
{
    [self removeAdsAndMakePermanent:NO andRemember:NO];
}

#pragma mark Restart Ad Serving

- (void)restartAdsAfterDelay:(NSTimeInterval)delay
{
    // This method restores ads to the view by creating a new banner, intended to be used after removeBanner permanently is called.
    // NOTE: The boolean _adsRemoved is taken into account.
    
    if (!_adsRemoved && !_showingAd) {
        CJPLog(@"Restarting ad serving...");
        [self performSelector:@selector(createBanner) withObject:nil afterDelay:delay];
    }
}

- (void)restartAds
{
    [self restartAdsAfterDelay:0.0];
}


#pragma mark -
#pragma mark View Methods

- (void)layoutAds
{
    [self.view setNeedsLayout];
}

// Returns the currently visible view controller from either the UINavigationController or UITabBarController holding the content
- (UIViewController *)currentViewController
{
    return (UIViewController*)[_contentController.childViewControllers lastObject];
}

- (BOOL)prefersStatusBarHidden
{
    // Return the application's statusBarHidden if the UIViewControllerBasedStatusBarAppearance key has not been added to Info.plist
    // Otherwise return the prefersStatusBarHidden set by the view controller
    if (![[NSBundle mainBundle] objectForInfoDictionaryKey:@"UIViewControllerBasedStatusBarAppearance"]) {
        return [UIApplication sharedApplication].statusBarHidden;
    }
    else {
        return [self currentViewController].prefersStatusBarHidden;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    // Return the application's statusBarStyle if the UIViewControllerBasedStatusBarAppearance key has not been added to Info.plist
    // Otherwise return the preferredStatusBarStyle set by the view controller
    if (![[NSBundle mainBundle] objectForInfoDictionaryKey:@"UIViewControllerBasedStatusBarAppearance"]) {
        return [UIApplication sharedApplication].statusBarStyle;
    }
    else {
        return [self currentViewController].preferredStatusBarStyle;
    }
}

- (BOOL)shouldAutorotate
{
    return [[self currentViewController] shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self currentViewController].supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self currentViewController].preferredInterfaceOrientationForPresentation;
}

- (void)viewDidLayoutSubviews
{
    BOOL isPortrait = UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]);
    BOOL isPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? YES : NO;
    CGRect contentFrame = self.view.bounds;
    CGRect bannerFrame = CGRectZero;
    
    // If an AdMob view has been created we'll figure out which views need adjusting
    if (_useAdMobSmartSize) {
        _adMobView.adSize = isPortrait ? kGADAdSizeSmartBannerPortrait : kGADAdSizeSmartBannerLandscape;
        bannerFrame = _adMobView.frame;
    }
    else {
        // Legacy AdMob doesn't have different orientation sizes - we just need to change the X offset so the ad remains centered
        bannerFrame = _adMobView.frame;
        CGRect screen = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = isPortrait ? CGRectGetWidth(screen) : CGRectGetHeight(screen);
        GADAdSize adMobSize = isPad ? kGADAdSizeLeaderboard : kGADAdSizeBanner;
        CGSize cgAdMobSize = CGSizeFromGADAdSize(adMobSize);
        CGFloat adMobXOffset = (screenWidth-cgAdMobSize.width)/2;
        bannerFrame.origin.x = adMobXOffset;
        _adMobView.frame = bannerFrame;
    }
    
    // Now if we actually have an ad to display
    if (_showingAd) {
        CJPLog(@"AdView exists and ad is being shown.");
        
        contentFrame.size.height -= bannerFrame.size.height;
        bannerFrame.origin.y = contentFrame.size.height;
    }
    // Or if we don't...
    else {
        CJPLog(@"AdView exists but there is currently no ad to be shown. Waiting for new ad...");
        bannerFrame.origin.y = contentFrame.size.height;
    }
    
    if (_showingAd) _adMobView.frame = bannerFrame;
    
    _contentController.view.frame = contentFrame;
}

#pragma mark - AdMob Delegate Methods

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView
{
    CJPLog(@"New AdMob ad received.");
    
    _showingAd = YES;
    _adMobView.hidden = NO;
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         [self layoutAds];
                     }
                     completion:^(BOOL finished){
                         // Ensure view isn't behind the container and untappable
                         if (finished) [_containerView bringSubviewToFront:_adMobView];
                     }];
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error
{
    // Ensure view is hidden off screen
    if (_adMobView.frame.origin.y>=0 && _adMobView.frame.origin.y < _containerView.frame.size.height) {
        [self removeBannerAndPermanently:NO];
    }
    _showingAd = NO;
    
    CJPLog(@"Failed to receive AdMob. %@", error.localizedDescription);
    
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutAds];
    }];
}

// Unused AdMob delegate methods
//- (void)adViewWillPresentScreen:(GADBannerView *)bannerView
//{
//
//}

//- (void)adViewDidDismissScreen:(GADBannerView *)bannerView
//{
//
//}

//- (void)adViewWillLeaveApplication:(GADBannerView *)bannerView
//{
//
//}

#pragma mark - AdMob Targeting

- (void)setLocationWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude accuracy:(CGFloat)accuracyInMeters
{
    _adMobUserLocation = @{
                           @"latitude" : [NSNumber numberWithFloat:latitude],
                           @"longitude" : [NSNumber numberWithFloat:longitude],
                           @"accuracy" : [NSNumber numberWithFloat:accuracyInMeters]
                           };
}

@end
