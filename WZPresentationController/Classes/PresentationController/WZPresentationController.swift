//
//  WZPresentationController.swift
//
//  Created by 吴哲 on 2018/5/3.
//  Copyright © 2018年 arcangelw. All rights reserved.
//  UIPresentationController 交互容器

import UIKit

@objc public protocol WZPresentationTransitioning: AnyObject {
    /// presentedViewController.view 位置计算
    @objc(frameOfPresentedViewInContainerView:)
    func frameOfPresentedView(inContainerView containerView: UIView) -> CGRect
    
    /// presenting 转场动画  optional
    @objc(animatedTransitioning:)
    optional func animatedTransitioning(isPresenting: Bool) -> UIViewControllerAnimatedTransitioning?
}

@available(iOS 8.0, *)
open class WZPresentationController: UIPresentationController {
    
    @objc public let maskView:WZPresentationMaskView
    
    @objc required public init(presentedViewController presented: UIViewController,
                               presentingViewController presenting: UIViewController? = nil,
                               maskViewClass: WZPresentationMaskView.Type = WZPresentationMaskView.self,
                               effect: UIBlurEffect? = nil) {
        
        self.maskView = maskViewClass.init(effect:effect ,presentedViewController:presented)
        super.init(presentedViewController: presented, presenting: presenting)
        presented.modalPresentationStyle = .custom
        presented.transitioningDelegate = self
    }
    
    override open var frameOfPresentedViewInContainerView: CGRect
    {
        guard let transitioning = presentedViewController as? WZPresentationTransitioning,
            let `containerView` = containerView else {
                return super.frameOfPresentedViewInContainerView
        }
        return transitioning.frameOfPresentedView(inContainerView: containerView)
    }
    
    open override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        maskView.frame = containerView?.bounds ?? UIScreen.main.bounds
        presentedViewController.view.frame = frameOfPresentedViewInContainerView
    }
    
    override open func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()

        maskView.frame = containerView?.bounds ?? UIScreen.main.bounds
        containerView?.addSubview(maskView)
        presentedViewController.view.frame = frameOfPresentedViewInContainerView
        containerView?.addSubview(presentedViewController.view)
        
        if let transitionCoordinator = presentingViewController.transitionCoordinator {
            maskView.layer.opacity = 0.0
            transitionCoordinator.animate(alongsideTransition: { [weak self] _ in
                self?.maskView.layer.opacity = 1.0
                }, completion:nil)
        }
    }
    
    open override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        guard !completed else { return }
        maskView.removeFromSuperview()
    }
    
    override open func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        guard let transitionCoordinator = presentingViewController.transitionCoordinator else { return }
        transitionCoordinator.animate(alongsideTransition: { [weak self] _ in
            self?.maskView.layer.opacity = 0.0
            }, completion:nil)
    }
    
    override open func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        guard completed else { return }
        maskView.removeFromSuperview()
    }
    
}

// MARK: - UIViewControllerTransitioningDelegate
extension WZPresentationController: UIViewControllerTransitioningDelegate {
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return self
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return (presentedViewController as? WZPresentationTransitioning)?.animatedTransitioning?(isPresenting: true)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return (presentedViewController as? WZPresentationTransitioning)?.animatedTransitioning?(isPresenting: false)
    }
    
    @available(iOS 8.3, *)
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
