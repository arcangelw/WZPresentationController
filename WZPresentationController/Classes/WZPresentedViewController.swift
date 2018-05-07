//
//  WZPresentedViewController.swift
//
//  Created by 吴哲 on 2018/5/3.
//  Copyright © 2018年 arcangelw. All rights reserved.
//  一个基础的presentedViewController
//  封装了基础的presentation业务逻辑

import UIKit

open class WZPresentedViewController: UIViewController {
    
    /// 指定允许用户与之交互的UIView实例数组 默认为空
    public var passthroughViews:[UIView] = [UIView]()
    
    /// 点击遮罩dismiss presentedViewController 默认不可以
    public var dismissPresentedOnTap:Bool = false
    
    /// 遮罩透明度 默认0.3
    public var maskAlpha:CGFloat = 0.3
    
    /// 转场动画类型
    public var transitionType:WZPresentationAnimatedTransitionType = .alertNormal
    
    /// 继承WZPresentationMaskView 可以自定义遮罩
    public let maskViewClass:WZPresentationMaskView.Type
    
    /// 继承WZPresentationController 可以自定义presentation容器
    public let presentationControllerClass:WZPresentationController.Type
    
    deinit {
        passthroughViews = []
    }
    
    required public init(maskViewClass:WZPresentationMaskView.Type = WZPresentationMaskView.self , presentationControllerClass:WZPresentationController.Type = WZPresentationController.self){
        self.maskViewClass = maskViewClass
        self.presentationControllerClass = presentationControllerClass
        super.init(nibName: nil, bundle: nil)
        super.modalPresentationStyle = .custom
        super.transitioningDelegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension WZPresentedViewController:UIViewControllerTransitioningDelegate {
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return self.presentationControllerClass.init(presentedViewController: presented, presenting: presenting)
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionType.presentationAnimatedTransition()
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionType.presentationAnimatedTransition(isPresent: false)
    }
    
    @available(iOS 8.3, *)
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
