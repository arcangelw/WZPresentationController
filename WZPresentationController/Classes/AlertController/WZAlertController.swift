//
//  WZAlertController.swift
//  WZPresentationController
//
//  Created by 吴哲 on 2018/10/11.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit


final public class WZAlertController: UIViewController {
    
    @objc public let contentView: WZPresentedViewTransitioning
    
    @objc public fileprivate(set) var presentation: WZPresentationController!
    
    @objc required public init(contentView: WZPresentedViewTransitioning, nibName: String? = nil, bundle: Bundle? = nil) {
        self.contentView = contentView
        super.init(nibName: nibName, bundle: bundle)
        preferredContentSize = contentView.preferredContentSize
        presentation = contentView.presentationClass.init(presentedViewController: self, effect: contentView.maskEffect)
        presentation.maskView.passthroughViews = contentView.passthroughViews
        presentation.maskView.dismissPresentedOnTap = contentView.dismissPresentedOnTap
        presentation.maskView.maskAlpha = contentView.maskAlpha
        print("\(self.contentView.preferredContentSize)   \(self.contentView.dismissPresentedOnTap)  \(contentView.passthroughViews)")
    }
    
    required internal init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func loadView() {
        super.loadView()
        self.view = contentView as! UIView
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contentView.presentedViewWillAppear?(animated)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentView.presentedViewDidAppear?(animated)
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        contentView.presentedViewWillDisappear?(animated)
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        contentView.presentedViewDidDisappear?(animated)
    }
}

extension WZAlertController:WZPresentationTransitioning {
    
    open func frameOfPresentedView(inContainerView containerView: UIView) -> CGRect {
        return contentView.frameOfPresentedView(inContainerView:containerView)
    }
    
    open func animatedTransitioning(isPresenting: Bool) -> UIViewControllerAnimatedTransitioning? {
        return contentView.animatedTransitioning?(isPresenting: isPresenting)
    }
}
