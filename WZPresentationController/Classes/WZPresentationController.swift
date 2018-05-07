//
//  WZPresentationController.swift
//
//  Created by 吴哲 on 2018/5/3.
//  Copyright © 2018年 arcangelw. All rights reserved.
//  UIPresentationController 交互容器

import UIKit

open class WZPresentationController: UIPresentationController {
    
    fileprivate let maskView:WZPresentationMaskView
    
    required public override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        guard let presented = presentedViewController as? WZPresentedViewController else {
            fatalError("presentedViewController is not WZPresentedViewController")
        }
        self.maskView = presented.maskViewClass.init(presentedViewController:presented)
        super.init(presentedViewController: presented, presenting: presentingViewController)
    }
    
    override open var frameOfPresentedViewInContainerView: CGRect
    {
        let rect = super.frameOfPresentedViewInContainerView
        guard let presented = presentedViewController as? WZPresentedViewController else {
            return rect
        }
        let pSize = presented.preferredContentSize
        let x =  (rect.width - pSize.width) / 2.0
        let y = presented.transitionType.isActionSheet ? (rect.height - pSize.height) : ((rect.height - pSize.height) / 2.0)
        return CGRect(origin: CGPoint(x: x, y: y), size: pSize)
    }
    
    open override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        maskView.frame = containerView?.bounds ?? UIScreen.main.bounds
    }
    
    override open func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        /// 在展现的时候 设置必要参数
        guard let presented = presentedViewController as? WZPresentedViewController else {
            return
        }
        maskView.setBlurEffect(withView: presentingViewController.view, type: presented.transitionType.blurEffectType)
        maskView.frame = containerView?.bounds ?? UIScreen.main.bounds
        containerView?.addSubview(maskView)
        maskView.dismissPresentedOnTap = presented.dismissPresentedOnTap
        maskView.passthroughViews = presented.passthroughViews
        maskView.backgroundColor = UIColor.black.withAlphaComponent(presented.maskAlpha)
        maskView.layer.opacity = 0.0
        presented.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.maskView.layer.opacity = 1.0
        }, completion:nil)
    }
    
    override open func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.maskView.layer.opacity = 0.0
        }, completion:nil)
    }
    
    override open func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        if completed {
            maskView.removeFromSuperview()
        }
    }
    
}
