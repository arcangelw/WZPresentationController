//
//  WZPresentationBaseAnimatedTransition.swift
//
//  Created by 吴哲 on 2018/5/4.
//  Copyright © 2018年 arcangelw. All rights reserved.
//  转场动画基础类

import UIKit

open class WZPresentationBaseAnimatedTransition: NSObject {
    /// true present false dismiss
    public let isPresent: Bool
    
    required public init(isPresent:Bool){
        self.isPresent = isPresent
        super.init()
    }
    
    /// present 动画实现
    open func presentAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        fatalError("没有实现present动画")
    }
    
    /// dismiss 动画实现
    open func dismissAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let from = transitionContext.viewController(forKey: .from) else { return }
        UIView.animate(withDuration: 0.25, delay: 0.0, options:.curveEaseInOut, animations: {
            from.view.layer.opacity = 0.0
            from.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

// MARK: - UIViewControllerAnimatedTransitioning
extension WZPresentationBaseAnimatedTransition: UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresent {
            presentAnimateTransition(using: transitionContext)
        }else {
            dismissAnimateTransition(using: transitionContext)
        }
    }
}
