# WZPresentationController

[![CI Status](https://img.shields.io/travis/arcangelw/WZPresentationController.svg?style=flat)](https://travis-ci.org/arcangelw/WZPresentationController)
[![Version](https://img.shields.io/cocoapods/v/WZPresentationController.svg?style=flat)](https://cocoapods.org/pods/WZPresentationController)
[![License](https://img.shields.io/cocoapods/l/WZPresentationController.svg?style=flat)](https://cocoapods.org/pods/WZPresentationController)
[![Platform](https://img.shields.io/cocoapods/p/WZPresentationController.svg?style=flat)](https://cocoapods.org/pods/WZPresentationController)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

* 效果图(gif图压缩，实际效果请运行demo)

![](https://github.com/arcangelw/WZPresentationController/blob/master/demo.gif)

## Introduction
WZPresentationController 是对 UIPresentationController 的简单封装
项目组很多人各种向keyWindow添加View的方式实现alert / sheet 等功能带来了无尽的麻烦，相信很多人深有体会啊

* WZPresentedViewController

```
	继承指定preferredContentSize
	设置WZPresentationAnimatedTransitionType给定的基础alert/actionSheet
	可以实现自定义的alert/actionSheet提示窗
	也可以注册实现以下子类实现自定义功能
```

* WZPresentationMaskView

```
	蒙板，默认提供了
	passthroughViews:指定允许用户与之交互的UIView实例数组
	dismissPresentedOnTap:点击遮罩dismiss presentedViewController
	WZPresentationAnimatedTransitionType中指定UIBlurEffectStyle可以实现模糊背景
	继承重写注册给WZPresentedViewController可以自定义相关功能需求
```

* WZPresentationController

```
	实现了WZPresentationMaskView的注册加载
	指定alert/actionSheet两种布局格式
	继承重写注册给WZPresentedViewController可以自定义相关功能需求
```

* WZPresentationAnimatedTransitionType

```
	提供了自定义扩展和基础转场动画 
```

* WZPresentationBaseAnimatedTransition

```
	继承WZPresentationBaseAnimatedTransition自定义转场动画
	通过WZPresentationAnimatedTransitionType
	case custom(WZPresentationBaseAnimatedTransition.Type)
	注册给WZPresentedViewController实现
```


## Requirements
* **iOS 8** and up

## Installation

WZPresentationController is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'WZPresentationController'
```

## Author

arcangelw, wuzhezmc@gmail.com

## License

WZPresentationController is available under the MIT license. See the LICENSE file for more info.
