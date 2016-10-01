# CJPAdMobHelper 1.0

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

## Configuration Options

### Delay the appearance of ads after app has launched
By default, ads will be requested as soon as your app is launched. You can delay this by providing an NSTimeInterval, the following code would wait 5 seconds after your app has launched before requesting an ad:

```objective-c
[CJPAdMobHelper sharedInstance].initialDelay = 5.0;
```

## Targeting
There are a number of specific options that can also be configured, as well as a number of general methods for hiding, removing, restoring ads etc.
AdMob ads may also be targeted based on your users' age, gender and location. Please read the comments in the header file before using any of these.
You can see an example of these in the demo project, furthermore, the header file is well commented with information on what each method does and how you might want to use them both in testing or in production.


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
