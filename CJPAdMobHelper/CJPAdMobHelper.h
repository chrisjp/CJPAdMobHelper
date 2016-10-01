//
//  CJPAdMobHelper.h
//  CJPAdMobHelper
//
//  Created by Chris Phillips on 30/09/2016.
//  Copyright © 2016 Midnight Labs Ltd. All rights reserved.
//


// Testing things? Uncomment the line below and various events will be logged.
//#define DEBUG_CJPADMOBHELPER

#import <GoogleMobileAds/GoogleMobileAds.h>

@interface CJPAdMobHelper : UIViewController <GADBannerViewDelegate>

// Get the shared instance
+ (CJPAdMobHelper *)sharedInstance;

// This should be a UINavigationController. Other view controllers may work but have not been tested
// Calling this method from your app delegate will begin the serving of ads.
- (void)startWithViewController:(UIViewController *)contentController;

/* 
 Call this method to remove ads from the view
 
 If `permanent` is set to YES, ads will not show until the app is next launched, or until the restartAds method is called.
 
 When set to NO, ads will only be removed off-screen temporarily - typically just a few minutes until the delegate receives a new ad.
 You probably won't have a use for this in production, but may find it useful when testing.

 If `permanent` AND `remember` are both set to YES, a boolean will be set in NSUserDefaults to remember this across future app launches.
 A typical use of this might be if your user purchases an IAP to remove ads from the app.
*/
- (void)removeAdsAndMakePermanent:(BOOL)permanent andRemember:(BOOL)remember;

// A shortcut equivalent to calling removeAdsAndMakePermanent:NO andRemember:NO;
- (void)removeAds;

/*
 Call this method to restart ad serving.
 
 This is intended to be called after removeAdsAndMakePermanent:YES has been called.
 It WILL take into account the andRemember boolean though, so ad serving will not be restarted
 if the boolean in NSUserDefaults is true.
*/
- (void)restartAdsAfterDelay:(NSTimeInterval)delay;

// Shortcut for calling the above method with no delay (instantly restore ads to the view)
- (void)restartAds;



/* SETTINGS */

/// Length of time in seconds to wait before attempting to show an ad after the app is launched (default: 0.0)
@property (nonatomic, assign) NSTimeInterval initialDelay;


/* OTHER SETTINGS */

// This will be set automatically based on a NSUserDefaults boolean.
// It will always be NO unless you have called [[CJPAdController sharedInstance] removeAdsAndMakePermanent:YES andRemember:YES];
// This property is here simply for convenience, allowing you to manually set it to YES from your app delegate if you wish to use your app without ads while testing for example.
@property (nonatomic, assign) BOOL adsRemoved;


/* ADMOB SPECIFIC SETTINGS */

/// AdMob Unit ID for the banner you want to display.
// This will be a long string containing your Google publisher ID following by an identifier for the banner
// It should look similar to the following: ca-app-pub-1234567890987654/1234567890
@property (nonatomic, copy) NSString *adMobUnitID;

/// Use AdMob's "Smart Size" banners? By default this is set to YES.
/// If set to NO, 320x50 ads will be used for iPhone/iPod and 728x90 for iPad.
// For more info see: https://firebase.google.com/docs/admob/ios/banner#banner_size
@property (nonatomic, assign) BOOL useAdMobSmartSize;

/// An array of UDID strings of devices that you want to show AdMob test ads on.
@property (nonatomic, copy) NSArray *testDeviceIDs;

/*
 From: https://firebase.google.com/docs/admob/ios/targeting#child-directed_setting
 If you set tagForChildDirectedTreatment to 1, you will indicate that your content should be treated as child-directed for purposes of COPPA.
 If you set tagForChildDirectedTreatment to 0, you will indicate that your content should not be treated as child-directed for purposes of COPPA.
 If you do not set tagForChildDirectedTreatment, ad requests will include no indication of how you would like your content treated with respect to COPPA.
 By setting this tag, you certify that this notification is accurate and you are authorized to act on behalf of the owner of the app. You understand that abuse of this setting may result in termination of your Google account.
 */
/// COPPA Compliance - You must read the guidelines above before using this. By default it is left unset, but can be set to "0" or "1".
@property (nonatomic, copy) NSString *tagForChildDirectedTreatment;

// Targeting
/*
 Before using any of the following properties or methods, please read this page: https://firebase.google.com/docs/admob/ios/targeting
 AdMob allows you to target the ads shown to your users, based on their gender, age and/or location.
 Google stresses that you should only use this demographic data if your app already makes use of it.
 i.e. don't collect this data from your user's solely for the pupose of showing targeted ads to them.
 
 GADRequest.h is also commented with notes on using this kind of data
 
 If you do not wish to show targeted ads to your users, you can just ignore all this and don't set any of these values in your app delegate.
*/

/// Gender - Optional. Either kGADGenderMale or kGADGenderFemale. Can be used to improve ad relevancy.
@property (nonatomic, assign) GADGender adMobGender;

/// Birthday - Optional. NSDate of the user's birthday. Can be used to improve ad relevancy.
@property (nonatomic, copy) NSDate *adMobBirthday;

/// Location - Optional. If you're using CoreLocation you can provide the user's location with this method.
- (void)setLocationWithLatitude:(CGFloat)latitude
                      longitude:(CGFloat)longitude
                       accuracy:(CGFloat)accuracyInMeters;

@end
