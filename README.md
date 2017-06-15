# URWeatherView
 [![Swift](https://img.shields.io/badge/Swift-3.0%2B-orange.svg)](https://swift.org) [![podplatform](https://cocoapod-badges.herokuapp.com/p/URWeatherView/badge.png)](https://cocoapod-badges.herokuapp.com/p/URWeatherView/badge.png) [![pod](https://cocoapod-badges.herokuapp.com/v/URWeatherView/badge.png)](https://cocoapods.org/pods/URWeatherView) ![poddoc](https://img.shields.io/cocoapods/metrics/doc-percent/URWeatherView.svg) ![license](https://cocoapod-badges.herokuapp.com/l/URWeatherView/badge.png) ![travis](https://travis-ci.org/jegumhon/URWeatherView.svg?branch=master) [![codecov](https://codecov.io/gh/jegumhon/URWeatherView/branch/master/graph/badge.svg)](https://codecov.io/gh/jegumhon/URWeatherView) [![CocoaPods compatible](https://img.shields.io/badge/CocoaPods-compatible-4BC51D.svg?style=flat)](https://github.com/CocoaPods/CocoaPods) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## What is this for?
Show the weather effect onto view for **Swift3**  
This code style is the **`Protocol Oriented Programming`**.

To show the vector animation made by After Effect, [Lottie](http://airbnb.design/lottie/) can be used instead of UIImageView.

### Usable Weather Effects

#### 1. Snow
![sample](https://github.com/jegumhon/URWeatherView/blob/master/Resources/parallaxScrolling+PullToRefresh1.gif?raw=true)

#### 2. Rain
![sample](https://github.com/jegumhon/URWeatherView/blob/master/Resources/parallaxScrolling+PullToRefresh1.gif?raw=true)

#### 3. Dust
  * #1  
![sample](https://github.com/jegumhon/URWeatherView/blob/master/Resources/parallaxScrolling+PullToRefresh1.gif?raw=true)
  * #2  
![sample](https://github.com/jegumhon/URWeatherView/blob/master/Resources/parallaxScrolling+PullToRefresh1.gif?raw=true)

#### 4. Lightning
![sample](https://github.com/jegumhon/URWeatherView/blob/master/Resources/parallaxScrolling+PullToRefresh1.gif?raw=true)

#### 5. Hot
![sample](https://github.com/jegumhon/URWeatherView/blob/master/Resources/parallaxScrolling+PullToRefresh1.gif?raw=true)

#### 6. Cloudy
![sample](https://github.com/jegumhon/URWeatherView/blob/master/Resources/parallaxScrolling+PullToRefresh1.gif?raw=true)

## Used library stack
#### [SpriteKit](https://developer.apple.com/spritekit/)  
#### [CIFilter](https://github.com/airbnb/lottie-ios) &  [CIKernel](https://developer.apple.com/documentation/coreimage/cikernel) & [Core Imager Kernel Language(like GLSL)](https://developer.apple.com/library/content/documentation/GraphicsImaging/Reference/CIKernelLangRef/ci_gslang_ext.html)  
#### [Lottie](https://github.com/airbnb/lottie-ios)  
  * I needed to apply color filter for the weather effect.  
    So, I made custom Lottie library to get some properties from LOTAnimationView.
  * It's [lottie-ios-extension](https://github.com/jegumhon/lottie-ios).

## Requirements

* iOS 9.0+
* Swift 3.0+

## Installation

### Cocoapods

Add the following to your `Podfile`.

    pod "URParallaxScrollAnimator"
    
#### Dependency

[lottie-ios-extension](https://github.com/jegumhon/lottie-ios)  
(But, you don't need to care about this, when using URWeatherView. It's already included the dependency.)

### Carthage

Add the following to your `Cartfile`.

    github "jegumhon/URWeatherView", "library"
    
#### Dependency

[lottie-ios-extension](https://github.com/jegumhon/lottie-ios)  
(But, you don't need to care about this, when using URWeatherView. It's already included the dependency.)

## Examples

See the `Example` folder.  
Run `pod install` and open the .xcworkspace.  
or  
Run `carthage update` and open the .xcodeproj.

## Usage

```swift
import URWeatherView
```

** not finished to write the explanation of Usage...  
ASAP, I'll finish this. **

## To-Do

- [ ] exchange the Core Image Kernel to [Metal](https://developer.apple.com/metal/).

## License

URWeatherView is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
