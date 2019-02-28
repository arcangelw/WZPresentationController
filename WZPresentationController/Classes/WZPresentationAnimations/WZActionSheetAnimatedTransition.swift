//
//  HXActionSheetAnimatedTransition.swift
//
//  Created by 吴哲 on 2018/5/4.
//  Copyright © 2018年 arcangelw. All rights reserved.
//

import UIKit

class HXActionSheetAnimatedTransition: WZPresentationBaseAnimatedTransition {
    
    override func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard var from = transitionContext.viewController(forKey: .from),
            var to = transitionContext.viewController(forKey: .to)
            else { return }
        
        let containerView = transitionContext.containerView
        let duration = self.transitionDuration(using: transitionContext)
        
        var start = CGAffineTransform(translationX: 0.0, y: to.view.frame.height)
        var end = CGAffineTransform.identity
        
        if isPresent == false {
            swap(&from, &to)
            swap(&start, &end)
        } else {
            /// 只有在 present 时候 需要将 to.view 添加到 containerView
            to.view.frame = to.presentationController!.frameOfPresentedViewInContainerView
            containerView.addSubview(to.view)
        }
        
        to.view.transform = start
        UIView.animate(withDuration: duration, delay: 0.0, options:UIView.AnimationOptions(rawValue: 7 << 16 | UIView.AnimationOptions.allowAnimatedContent.rawValue), animations: {
            to.view.transform = end
        }) { finished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
