
# AnyAlert

#### v2.1.0

Customizable Alert message for Objective-C and Swift

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
    - [CocoaPods](#cocoapods)
    - [Carthage](#carthage)
    - [Swift Pacakge Manager](#swift-pacakge-manager)
    - [Manually](#manually)
- [Usage](#usage)
    - [Edit info.plist](#edit-info-plist)
    - [Import AnyAlert](#import-anyalert)
    - [Showing an Alert](#showing-an-alert)
    - [Showing an Alert with Tap Handler](#showing-an-alert-with-tap-handler)
- [Source Code](#source-code)
- [Credits](#credits)
- [License](#license)


## Features

- [x] Customizable everything
- [x] iPhoneX support
- [x] Use Objective-C or Swift 3.0+


## Requirements

- Xcode 9.0+
- iOS 9.0+
- Objective-C or Swift 3.0+


## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org)

`pod 'AnyAlert', '2.1.0'`

### Carthage

[Carthage](https://github.com/Carthage/Carthage)

... coming soon ...

### Swift Pacakge Manager

[Swift Pacakage Manager](https://swift.org/package-manager/)

... coming soon ...

### Manually

Import the following 6 files into your project: [AnyAlert-iOS @ GitHub](https://github.com/ChrisAllinson/AnyAlert-iOS/tree/2.1.0/AnyAlert/AnyAlert).


---


## Usage

### Edit info plist

`View controller-based status bar appearance = NO`

### Import AnyAlert

Swift:

`import AnyAlert`

Objective-C:

`#import "AnyAlert-Swift.h"`

`@protocol AnyAlertManagerInput;`

### Showing an Alert

Simply create an `AnyAlert`, then call `AnyAlertManager.show(_ alert: AnyAlert, from vc: UIViewController)`:

Swift:
```
let tempAlert: AnyAlert = AnyAlert(
    message: "Test Message",
    backgroundColor: .red,
    statusBarStyle: .lightContent,
    messageFont: UIFont.systemFont(ofSize: 16.0),
    messageColor: .white,
    closeButtonFont: UIFont.systemFont(ofSize: 16.0),
    closeButtonColor: .white,
    height: 95.0,
    openSpeed: 0.5,
    closeSpeed: 0.5,
    doesSelfDismiss: false,
    showFor: 2.0
)

AnyAlertManager.show(tempAlert, from: self)
```

Objective-C:
```
AnyAlert *tempAlert = [[AnyAlert alloc] initWithMessage: @"Test Message"
                                        backgroundColor: [UIColor redColor]
                                        statusBarStyle: UIStatusBarStyleLightContent
                                        messageFont: [UIFont boldSystemFontOfSize:12.0]
                                        messageColor: [UIColor whiteColor]
                                        closeButtonFont: [UIFont boldSystemFontOfSize:12.0]
                                        closeButtonColor: [UIColor whiteColor]
                                        height: 95.0
                                        openSpeed: 0.5
                                        closeSpeed: 0.5
                                        doesSelfDismiss: false
                                        showFor: 1.0];

[AnyAlertManager show:tempAlert from:self];
```

### Showing an Alert with Tap Handler

Simply create an `AnyAlert`, then call `AnyAlertManager.show(_ alert: AnyAlert, from vc: UIViewController, tapHandler: @escaping (() -> Void))`:

Swift:
```
let tempAlert: AnyAlert = AnyAlert(
    message: "Test Message",
    backgroundColor: .red,
    statusBarStyle: .lightContent,
    messageFont: UIFont.systemFont(ofSize: 16.0),
    messageColor: .white,
    closeButtonFont: UIFont.systemFont(ofSize: 16.0),
    closeButtonColor: .white,
    height: 95.0,
    openSpeed: 0.5,
    closeSpeed: 0.5,
    doesSelfDismiss: false,
    showFor: 2.0
)

AnyAlertManager.show(tempAlert, from: self, tapHandler: { _ in
    print("Tapped!")
})
```

Objective-C:
```
AnyAlert *tempAlert = [[AnyAlert alloc] initWithMessage: @"Test Message"
                                        backgroundColor: [UIColor redColor]
                                        statusBarStyle: UIStatusBarStyleLightContent
                                        messageFont: [UIFont boldSystemFontOfSize:12.0]
                                        messageColor: [UIColor whiteColor]
                                        closeButtonFont: [UIFont boldSystemFontOfSize:12.0]
                                        closeButtonColor: [UIColor whiteColor]
                                        height: 95.0
                                        openSpeed: 0.5
                                        closeSpeed: 0.5
                                        doesSelfDismiss: false
                                        showFor: 1.0];

[AnyAlertManager show:tempAlert from:self tapHandler:^(void){
    NSLog(@"TAPPED");
}];
```


---


## Source Code

[GitHub](https://github.com/ChrisAllinson/AnyAlert-iOS/tree/2.1.0/AnyAlert/AnyAlert)


## Credits

AnyAlert is owned and maintained by [Chris Allinson](http://www.allinson.ca).


## License

AnyAlert is released under the MIT license. See LICENSE for details.
