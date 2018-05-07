//
//  WZPresentationMaskView.swift
//
//  Created by 吴哲 on 2018/5/3.
//  Copyright © 2018年 arcangelw. All rights reserved.
//  图层遮罩

import UIKit

open class WZPresentationMaskView: UIView {
    /// 指定允许用户与之交互的UIView实例数组 默认为空
    public var passthroughViews:[UIView] = [UIView](){
        willSet{
            ///有可以交互UIView实例 默认打开dismissPresentedOnTap
            if newValue.count > 0 {
                self.dismissPresentedOnTap = true
            }
        }
    }
    
    /// 点击遮罩dismiss presentedViewController 默认不可以
    public var dismissPresentedOnTap:Bool = false
    
    /// 是否模糊
    public fileprivate(set) var isBlur = false
    
    weak var presentedViewController:WZPresentedViewController!
    
    deinit {
        passthroughViews = []
    }
    
    required public init(presentedViewController:WZPresentedViewController) {
        self.presentedViewController = presentedViewController
        super.init(frame: .zero)
        backgroundColor = UIColor.black.withAlphaComponent(0.3)
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
        if passthroughViews.count > 0 && self.isBlur == false && hit == self  {
            for c in passthroughViews {
                if let newHit = c.hitTest(self.convert(point, to: c), with: event) {
                    hit = newHit
                    animated = false
                    break
                }
            }
        }
        defer {
            if self.dismissPresentedOnTap == true {
                self.presentedViewController.dismiss(animated: animated, completion: nil)
                self.dismissPresentedOnTap = false
            }
        }
        return hit
    }
}


extension WZPresentationMaskView {
    
    public func setBlurEffect(withView view:UIView ,type:WZPresentationBlurEffectStyle?){
        guard let `type` = type else { return }
        guard let snapImage = view.wz_snapshotImage() else { return }
        ///模糊处理
        DispatchQueue.global().async {
            var blurImage:UIImage? = nil
            switch type {
            case .extraLight:
                blurImage = snapImage.wz_imageByBlurExtraLight
                break
            case .light:
                blurImage = snapImage.wz_imageByBlurLight
                break
            case .dark:
                blurImage = snapImage.wz_imageByBlurDark
                break
            }
            if let `blurImage` = blurImage {
                let blurColor = UIColor(patternImage: blurImage)
                DispatchQueue.main.async {
                    self.isBlur = true
                    self.backgroundColor = blurColor
                }
            }
        }
    }
}



