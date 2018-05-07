//
//  HXAlertFadeAnimatedTransition.swift
//
//  Created by 吴哲 on 2018/5/4.
//  Copyright © 2018年 arcangelw. All rights reserved.
//

import UIKit

class HXAlertFadeAnimatedTransition: WZPresentationBaseAnimatedTransition {

    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard var from = transitionContext.viewController(forKey: .from),
            var to = transitionContext.viewController(forKey: .to)
            else { return }
        
        let containerView = transitionContext.containerView
        let duration = self.transitionDuration(using: transitionContext)
        
        var start:Float =  0.0
        var end:Float = 1.0
        
        if isPresent == false {
            swap(&from, &to)
            swap(&start, &end)
        }else{
            /// 只有在 present 时候 需要将 to.view 添加到 containerView
            to.view.frame = to.presentationController!.frameOfPresentedViewInContainerView
            containerView.addSubview(to.view)
        }
        to.view.layer.opacity = start
        UIView.animate(withDuration: duration, delay: 0.0, options:.curveEaseInOut, animations: {
            to.view.layer.opacity = end
        }) { finished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
