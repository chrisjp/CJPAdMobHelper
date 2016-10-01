//
//  ViewController.m
//  CJPAdMobHelper
//
//  Created by Chris Phillips on 30/09/2016.
//  Copyright © 2016 Midnight Labs Ltd. All rights reserved.
//

#import "ViewController.h"
#import "CJPAdMobHelper.h"

@interface ViewController ()

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UITextView *textView;
@property (nonatomic, strong) IBOutlet UIButton *btnPush;
@property (nonatomic, strong) IBOutlet UIButton *btnRemoveTemp;
@property (nonatomic, strong) IBOutlet UIButton *btnRemovePerm;
@property (nonatomic, strong) IBOutlet UIButton *btnRestore;

- (IBAction)removeAdsPermanently:(id)sender;
- (IBAction)removeAdsTemporarily:(id)sender;
- (IBAction)restoreAds:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (IBAction)removeAdsPermanently:(id)sender
{
    // In production, you might call this when someone makes an IAP to remove ads for example. In such a case, you'll want to set andRemember to NO so that it is remembered across future app launches.
    [[CJPAdMobHelper sharedInstance] removeAdsAndMakePermanent:YES andRemember:NO];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ads Removed" message:@"Ads will NOT show again until restored." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (IBAction)removeAdsTemporarily:(id)sender
{
    [[CJPAdMobHelper sharedInstance] removeAds];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ads Removed" message:@"Ads will be hidden off-screen until the next ad request fires (usually within 1-5 minutes)." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (IBAction)restoreAds:(id)sender
{
    // NOTE: restoreBanner's parameter can be left blank - if you're using multiple ad networks and have presumably removed any and all instances from your view before calling this, this will then create a new banner of your default ad type.
    [[CJPAdMobHelper sharedInstance] restartAds];
}



@end
