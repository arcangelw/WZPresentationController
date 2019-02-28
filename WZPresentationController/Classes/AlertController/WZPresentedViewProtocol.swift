//
//  WZPresentedView.swift
//  WZPresentationController
//
//  Created by 吴哲 on 2018/10/12.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit


@objc public protocol WZPresentedViewTransitioning:WZPresentationTransitioning where Self : UIView {
    
    // MARK: - 默认值仅仅针对Swift，ObjC请注意
    
    /// 设置 presentedViewController.preferredContentSize
    var preferredContentSize:CGSize { set get }
    ///  指定允许用户与之交互的UIView实例数组
    var passthroughViews:[UIView] { set get }
    /// 点击遮罩dismiss presentedViewController.view
    var dismissPresentedOnTap:Bool { set get }
    /// 遮罩透明度
    var maskAlpha:CGFloat { set get }
    /// 背景模糊设置
    var maskEffect:UIBlurEffect? { set get }
    
    var presentationClass:WZPresentationController.Type { set get }
    
    
    // MARK: - life cycle
    
    @objc optional func presentedViewWillAppear(_ animated: Bool)
    
    @objc optional func presentedViewDidAppear(_ animated: Bool)
    
    @objc optional func presentedViewWillDisappear(_ animated: Bool)
    
    @objc optional func presentedViewDidDisappear(_ animated: Bool)
    
}

// MARK: - show
extension UIView {
    
    /// presentedViewController presented in UIApplication.shared.delegate.window.rootViewController.visibleViewController
    @objc(showWithAnimated:completion:)
    public func show(animated flag: Bool, completion: (() -> Void)? = nil) {
        guard let presentedView = self as? WZPresentedViewTransitioning else { return }
        let alert = WZAlertController(contentView: presentedView)
        UIApplication.shared.wz_visibleViewController?.present(alert, animated: flag, completion: completion)
    }
}
