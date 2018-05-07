//
//  HXAlertDropDownAnimatedTransition.swift
//
//  Created by 吴哲 on 2018/5/4.
//  Copyright © 2018年 arcangelw. All rights reserved.
//

import UIKit

class HXAlertDropDownAnimatedTransition: WZPresentationBaseAnimatedTransition {
    
    override func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return isPresent ? 0.5 : 0.25
    }
    
    override func presentAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let to = transitionContext.viewController(forKey: .to) else { return }
        
        let containerView = transitionContext.containerView
        to.view.frame = to.presentationController!.frameOfPresentedViewInContainerView
        containerView.addSubview(to.view)
        to.view.transform = CGAffineTransform(translationX: 0.0, y: -to.view.frame.maxY)
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            to.view.transform = CGAffineTransform.identity
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
}
