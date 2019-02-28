//
//  WZPresentedViewController.swift
//
//  Created by 吴哲 on 2018/5/3.
//  Copyright © 2018年 arcangelw. All rights reserved.
//  一个基础的presentedViewController
//  封装了基础的presentation业务逻辑

import UIKit

@available(iOS 8.0, *)
open class WZPresentedViewController: UIViewController {
    
    /// 指定允许用户与之交互的UIView实例数组 默认为空
    @objc public var passthroughViews:[UIView] = [] {
        willSet{
            presentation.maskView.passthroughViews = newValue
        }
    }
    
    /// 点击遮罩dismiss presentedViewController 默认不可以
    @objc public var dismissPresentedOnTap = false {
        willSet{
            presentation.maskView.dismissPresentedOnTap = newValue
            
        }
    }
    
    /// 遮罩透明度 默认0.4
    @objc public var maskAlpha: CGFloat = 0.4 {
        willSet{
            presentation.maskView.maskAlpha = newValue
        }
    }
    
    /// 转场动画类型
    public var transitionType:WZPresentationAnimatedTransitionType = .alertNormal {
        willSet{
            presentation = presentationControllerClass.init(presentedViewController: self, maskViewClass: maskViewClass, effect: newValue.blurEffect)
            presentation.maskView.passthroughViews = passthroughViews
            presentation.maskView.dismissPresentedOnTap = dismissPresentedOnTap
            presentation.maskView.maskAlpha = maskAlpha
        }
    }
    
    /// 继承WZPresentationMaskView 可以自定义遮罩
    public let maskViewClass: WZPresentationMaskView.Type
    
    /// 继承WZPresentationController 可以自定义presentation容器
    public let presentationControllerClass: WZPresentationController.Type
    
    public fileprivate(set) var presentation: WZPresentationController!

    required public init(maskViewClass:WZPresentationMaskView.Type = WZPresentationMaskView.self , presentationControllerClass:WZPresentationController.Type = WZPresentationController.self){
        self.maskViewClass = maskViewClass
        self.presentationControllerClass = presentationControllerClass
        super.init(nibName: nil, bundle: nil)
        presentation = presentationControllerClass.init(presentedViewController: self, maskViewClass: maskViewClass, effect: transitionType.blurEffect)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - WZPresentationTransitioning
extension WZPresentedViewController: WZPresentationTransitioning {
    
    public func frameOfPresentedView(inContainerView containerView: UIView) -> CGRect {
        let rect = containerView.bounds
        let size = preferredContentSize
        let x =  (rect.width - size.width) / 2.0
        
        var y = transitionType.isActionSheet ? (rect.height - size.height ) : ((rect.height - size.height) / 2.0)
        if #available(iOS 11.0, *) {
            y -= transitionType.isActionSheet ? containerView.safeAreaInsets.bottom : 0.0
        }
        return CGRect(origin: CGPoint(x: x, y: y), size: size)
    }
    
    public func animatedTransitioning(isPresenting: Bool) -> UIViewControllerAnimatedTransitioning? {
        return transitionType.presentationAnimatedTransition(isPresent: isPresenting)
    }
}

