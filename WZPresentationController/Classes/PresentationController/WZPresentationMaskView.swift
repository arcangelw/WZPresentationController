//
//  WZPresentationMaskView.swift
//
//  Created by 吴哲 on 2018/5/3.
//  Copyright © 2018年 arcangelw. All rights reserved.
//  图层遮罩

import UIKit

@available(iOS 8.0, *)
open class WZPresentationMaskView: UIVisualEffectView {
    
    /// 指定允许用户与之交互的UIView实例数组 默认为空，存在时默认交互时候 dismiss presentedViewController
    @objc public var passthroughViews:[UIView] = []
    
    /// 点击遮罩dismiss presentedViewController 默认不可以
    @objc public var dismissPresentedOnTap = false
    
    /// 遮罩透明度 默认0.4
    public var maskAlpha:CGFloat = 0.4 {
        willSet{
            /// 有设置模糊的话 不设置透明色
            guard effect == .none else { return }
            backgroundColor = UIColor.black.withAlphaComponent(newValue)
        }
    }
    
    private weak var presentedViewController:UIViewController?
    
    required public init(effect: UIVisualEffect? , presentedViewController presented:UIViewController) {
        super.init(effect: effect)
        presentedViewController = presented
        /// 有设置模糊的话 不设置透明色
        guard effect == .none else { return }
        backgroundColor = UIColor.white.withAlphaComponent(maskAlpha)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        //        //presentedViewController.view 事件并不会传递过来 因此没必要做多余判断
        //        var dismiss = false
        //        if self.dismissPresentedOnTap == true {
        //            let toPoint = self.convert(point, to: self.presentedViewController.view)
        //            dismiss = self.presentedViewController.view.bounds.contains(toPoint) == false
        //        }
        var hit = super.hitTest(point, with: event)
        var animated = true

        defer {
            if dismissPresentedOnTap || !passthroughViews.isEmpty {
                presentedViewController?.dismiss(animated: animated, completion: nil)
                dismissPresentedOnTap = false
            }
        }

        if effect == .none && hit == self,
            let newHit = passthroughViews.first(where: { $0.hitTest(convert(point, to: $0), with: event) != .none }) {
            hit = newHit
            animated = false
        }

        return hit
    }
}
