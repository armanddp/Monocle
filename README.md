# Monocle

Monocle is an iOS player for circular video shot with [Snapchat Spectacles](https://spectacles.com).

![Spectacles](https://raw.githubusercontent.com/gizmosachin/Monocle/master/Specs.gif)

![Pod Version](https://img.shields.io/cocoapods/v/Monocle.svg) ![Carthage compatible](https://img.shields.io/badge/Carthage-Compatible-brightgreen.svg?style=flat) [![Build Status](https://travis-ci.org/gizmosachin/Monocle.svg?branch=master)](https://travis-ci.org/gizmosachin/Monocle)

## Version Compatibility

Monocle is written in Swift 3.0.

## Usage

Monocle is a `UIView` subclass that requires an `AVPlayer` instantiated with a circular video.

```swift
let monocle = Monocle()
monocle.player = AVPlayer(url: \* ... \*)
view.addSubview(monocle)
```

By default, Monocle responds to device motion events and rotates the video. You can disable this if you want.

```swift
monocle.shouldAutorotate = false
```

Note that Monocle only supports video exported by Snapchat that were shot with [Spectacles](https://spectacles.com).
Please see the [sample app](https://github.com/gizmosachin/Monocle/blob/master/Sample) for a basic implementation.

## Installation

### CocoaPods

Monocle is available for installation using [CocoaPods](http://cocoapods.org/). To integrate, add the following to your Podfile`:

``` ruby
platform :ios, '9.0'
use_frameworks!

pod 'Monocle', '~> 1.0'
```

### Carthage

Monocle is also available for installation using [Carthage](https://github.com/Carthage/Carthage). To integrate, add the following to your `Cartfile`:

``` odgl
github "gizmosachin/Monocle" >= 1.0
```

### Swift Package Manager

Monocle is also available for installation using the [Swift Package Manager](https://swift.org/package-manager/). Add the following to your `Package.swift`:

``` swift
import PackageDescription

let package = Package(
    name: "MyProject",
    dependencies: [
        .Package(url: "https://github.com/gizmosachin/Monocle.git", majorVersion: 0),
    ]
)
```

### Manual

You can also simply copy `Monocle.swift` into your Xcode project.

## License

Monocle is available under the MIT license, see the [LICENSE](https://github.com/gizmosachin/Monocle/blob/master/LICENSE) file for more information.
