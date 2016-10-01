//
//  AppDelegate.m
//  CJPAdMobHelper
//
//  Created by Chris Phillips on 30/09/2016.
//  Copyright © 2016 Midnight Labs Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "CJPAdMobHelper.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize navController = _navController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Setup CJPAdMobHelper...
    [CJPAdMobHelper sharedInstance].adMobUnitID = @"ca-app-pub-3940256099942544/2934735716";    // AdMob test ID - replace with your own
    // Optional settings
    [CJPAdMobHelper sharedInstance].testDeviceIDs = @[@"00000000000000000000000000000000",@"11111111111111111111111111111111"];
    [CJPAdMobHelper sharedInstance].useAdMobSmartSize = YES;    // defaults to YES anyway
    [CJPAdMobHelper sharedInstance].initialDelay = 0;
    
    // Targeting (all are optional and should only be used if your app already collects this information from users)
    /*
    // Gender
    [CJPAdMobHelper sharedInstance].adMobGender = kGADGenderMale;   // kGADGenderMale or kGADGenderFemale
    // Age
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = 1985;
    components.month = 1;
    components.day = 1;
    [CJPAdMobHelper sharedInstance].adMobBirthday = [[NSCalendar currentCalendar] dateFromComponents:components];
    // Location
    CLLocation *currentLocation = locationManager.location;
    if (currentLocation) {
        [[CJPAdMobHelper sharedInstance] setLocationWithLatitude:currentLocation.coordinate.latitude
                                                       longitude:currentLocation.coordinate.longitude
                                                        accuracy:currentLocation.horizontalAccuracy];
    }
    */
    // COPPA compliance
    // Don't use this unless you specifically want/need to declare your app as being directed to children (@"1") or not to children (@"0")
    //[CJPAdMobHelper sharedInstance].tagForChildDirectedTreatment = @"0";

    
    _navController = (UINavigationController*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
    
    [[CJPAdMobHelper sharedInstance] startWithViewController:_navController];
    self.window.rootViewController = [CJPAdMobHelper sharedInstance];
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
