//
//  HXAlertAnimatedTransition.swift
//
//  Created by 吴哲 on 2018/5/4.
//  Copyright © 2018年 arcangelw. All rights reserved.
//

import UIKit

class HXAlertAnimatedTransition: WZPresentationBaseAnimatedTransition {
    
    override func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return isPresent ? 0.45 : 0.25
    }
    
    override func presentAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let to = transitionContext.viewController(forKey: .to) else { return }
       
        let containerView = transitionContext.containerView
        to.view.frame = to.presentationController!.frameOfPresentedViewInContainerView
        containerView.addSubview(to.view)
        to.view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.25, delay: 0.0, options:.curveEaseInOut, animations: {
            to.view.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }) { _ in
            UIView.animate(withDuration: 0.2, delay: 0.0, options:.curveEaseInOut, animations: {
                to.view.transform = CGAffineTransform.identity
            }) { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }

}
