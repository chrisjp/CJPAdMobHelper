# CJPAdMobHelper 1.0.1

CJPAdMobHelper is a singleton class enabling easy implementation of Google AdMob banner ads in your iOS app.

There are some assumptions/limitations regarding intended usage. They include:
* This class is designed to be used in a `UINavigationController` showing a banner at the bottom of every view. Other classes may work but are neither supported nor tested.
* AdMob is your primary ad network.
* This class does not handle any mediation itself, it is assumed you will (optionally) use AdMob's front-end for mediation with other ad networks.
* Showing interstitial/videos or any other types of adverts is not currently supported but may be added in the future if time permits (feel free to submit a pull request if you have time to add this yourself).

## Features
* No need to add any views or constraints in your existing storyboards.
* Specify a time delay for when to start showing ads after the app is launched
* Works for both iPhone and iPad in any orientation (rotation is handled automatically) (iOS 8.x and later).
* Hides from view if there are no ads to display
* If you have an IAP allowing your users to disable ads there is method you can call to permanently hide ads for them


## Screenshots

[![CJPAdMobHelper screenshot](http://i.imgur.com/daylYpcm.png)](http://i.imgur.com/daylYpc.png) [![CJPAdMobHelper screenshot](http://i.imgur.com/RwaWJXhm.png)](http://i.imgur.com/RwaWJXh.png)


## Adding to your project

### Method 1 - CocoaPods

[CocoaPods](http://cocoapods.org) is the simplest way to get started. Just add `pod 'CJPAdMobHelper'` to your Podfile and run `pod install`.

### Method 2 - Old School

Drop the `CJPAdMobHelper` folder into your project and download and install the latest [**AdMob SDK**](https://firebase.google.com/docs/admob/ios/download), following any instructions in the readme.

## Usage

CJPAdMobHelper will automatically display ads at the top or bottom of your view. It is designed to be used with a UINavigationController.

**1.** `#import "CJPAdMobHelper.h"` in your `AppDelegate.m`.

**2.** In `application didFinishLaunchingWithOptions`, configure CJPAdMobHelper to your liking using the sharedInstance, you will at the very least need to provide the unit ID for the AdMob banner you want to display:

```objective-c
[CJPAdMobHelper sharedInstance].adMobUnitID = @"ca-app-pub-1234567890987654/1234567890";
```

**3.** Set up your navigation controller as usual, then tell CJPAdMobHelper to start serving ads in it.

```objective-c
[[CJPAdMobHelper sharedInstance] startWithViewController:_yourNavController];
```

**4.** One more thing... you'll need to set the window's rootViewController to the sharedInstance of CJPAdMobHelper

```objective-c
self.window.rootViewController = [CJPAdMobHelper sharedInstance];
```

## Optional Configuration

### Delay the appearance of ads after app has launched
`initialDelay` accepts an `NSTimeInterval`. By default, ads will be requested as soon as your app is launched. You can delay the initial ad request like so:

```objective-c
[CJPAdMobHelper sharedInstance].initialDelay = 5.0;
```

### Use AdMob "Smart" Banner Size
`useAdMobSmartSize` accepts a `BOOL`. By default this is set to `YES` as recommended. AdMob's "smart banner sizing" will show a standard banner across the full width of the screen, automatically adjusting for rotation on iPhone devices. You can disable this if you prefer by setting it to `NO`. In this case a centred 320x50 banner will be displayed on iPhone devices in both orientations, while iPad devices will show a centred 728x90 banner in both orientations.
For further information please see the AdMob docs: https://firebase.google.com/docs/admob/ios/banner#banner_size

```objective-c
[CJPAdMobHelper sharedInstance].useAdMobSmartSize = NO;
```

## Optional Targeting
Some parameters can be set to target ads more specifically to your users, including age, gender and location. Please note that AdMob strongly advises you only use targeting if your app already collects this data from your users for legitimate purposes, i.e. for reasons other than advertising. More info: https://firebase.google.com/docs/admob/ios/targeting

### Gender
`adMobGender` accepts one of AdMob's constants for the user's gender. `kGADGenderMale`, `kGADGenderFemale` or `kGADGenderUnknown` are available, unknown is assumed here so gender will only be sent if the male or female value is used.

```objective-c
[CJPAdMobHelper sharedInstance].adMobGender = kGADGenderMale;
```

### Age
`adMobBirthday` accepts an `NSDate` object containing the user's date of birth. If you store the day/month/year components instead of `NSDate` objects you can use code like this:

```objective-c
NSDateComponents *components = [[NSDateComponents alloc] init];
    		 components.year = 1985;
            components.month = 1;
			  components.day = 1;
[CJPAdMobHelper sharedInstance].adMobBirthday = [[NSCalendar currentCalendar] dateFromComponents:components]; 
```

### Location
`adMobUserLocation` accepts an `NSDictionary` object containing the latitude, longitude and accuracy from CoreLocation for the user's location. This can be easily set using the method `setLocationWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude accuracy:(CGFloat)accuracyInMeters`. Assuming you use CoreLocation your code might look something like this:

```objective-c
CLLocation *currentLocation = locationManager.location;
if (currentLocation) {
    [[CJPAdMobHelper sharedInstance] setLocationWithLatitude:currentLocation.coordinate.latitude
                                                   longitude:currentLocation.coordinate.longitude
                                                    accuracy:currentLocation.horizontalAccuracy];
}
```

### COPPA compliance
`tagForChildDirectedTreatment` accepts an `NSNumber` object using the `numberWithBool:` method (you can't just pass a BOOL because it needs to be checked for nil as well as just YES/NO). Please read the [AdMob docs](https://firebase.google.com/docs/admob/ios/targeting#child-directed_setting) before setting this.
> If you set tagForChildDirectedTreatment to YES, you will indicate that your content should be treated as child-directed for purposes of COPPA.
>
> If you set tagForChildDirectedTreatment to NO, you will indicate that your content should not be treated as child-directed for purposes of COPPA.
>
> If you do not set tagForChildDirectedTreatment, ad requests will include no indication of how you would like your content treated with respect to COPPA.
>
> By setting this tag, you certify that this notification is accurate and you are authorized to act on behalf of the owner of the app. You understand that abuse of this setting may result in termination of your Google account.


```objective-c
[CJPAdMobHelper sharedInstance].tagForChildDirectedTreatment = [NSNumber numberWithBool:YES];
```

## Licence and Attribution
If you're feeling kind you can provide attribution and a link to this GitHub project.


### Licence
Copyright (c) 2016 Chris Phillips

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

## Changes

### 1.0.1
* Better handling of COPPA setting
* Ensure test ads are shown when running in Simulator
* Updated README with information on all optional configuration and targeting settings

### 1.0.0
* Initial release
