SFHMemoryAlert
==============
Display the alert at the time of memory warning.

<img alt="Main Screenshot" src="https://dl.dropboxusercontent.com/u/16169330/memoryAlert.png" width="320px" style="width: 320px;" />

Install
==============
CocoaPods
==============
Add the lines below to your Podfile.
```
platform :ios, '7.0'

pod 'SFHMemoryAlert', :git => 'https://github.com/Econa77/SFHMemoryAlert.git'
```

Without CocoaPods
==============
Clone this repository.

```
git clone https://github.com/Econa77/SFHMemoryAlert.git
```

Copy `/SFHMemoryAlert` directory to your project .

Usage
==============
(see sample Xcode project in ./DemoApp.xcodeproj)

```objc
[SFHMemoryAlert setup];
[SFHMemoryAlert setAutoShowAlert:NO];  // Default YES
[SFHMemoryAlert setMaskType:SFHMemoryAlertMaskTypeNone]; // Defailt Black
[SFHMemoryAlert setCountAfterShowing:3]; // Default 0
```

1. Call `[SFHMemoryAlert setup]` . A good place to do this is at the beginning of your app delegate's `application:didFinishLaunchingWithOptions:` method.
2. (OPTIONAL) Call `[SFHMemoryAlert setAutoShowAlert:NO]`  if you don't show the alert automatically when receive didReceiveMemoryWarning, autoShowAlert set NO. 
3. (OPTIONAL) Call `[SFHMemoryAlert setMaskType:SFHMemoryAlertMaskTypeNone];`  when you change the maskType.
4. (OPTIONAL) Call `[SFHMemoryAlert setCountAfterShowing:3]` once the number of times until the display again after displaying the alert.When Receive didReceiveMemoryWarning, it is counted everytime.The default is 0.

Showing 
==============
You can show the alert at any time using one of the following:
```objc
+ (void)show;
+ (void)showWithMaskType:(SFHMemoryAlertMaskType)maskType;
```

Notifications
==============
SFHMemoryAlert posts four notifications via NSNotificationCenter in response to being shown/dismissed:

- SFHMemoryAlertWillAppearNotification when the show animation starts
- SFHMemoryAlertDidAppearNotification when the show animation completes
- SFHMemoryAlertWillDisappearNotification when the dismiss animation starts
- SFHMemoryAlertDidDisappearNotification when the dismiss animation completes

Requirements
==============
- iOS 7.0 or later
- ARC

License
==============
[MIT]: http://www.opensource.org/licenses/mit-license.php
[MIT license][MIT].

