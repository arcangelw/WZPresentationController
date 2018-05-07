//
//  WZPresentationAnimatedTransition.swift
//
//  Created by 吴哲 on 2018/5/3.
//  Copyright © 2018年 arcangelw. All rights reserved.
//  转场类型

import UIKit

/// 模糊类型
public enum WZPresentationBlurEffectStyle{
    case extraLight
    case light
    case dark
}

/// 基本转场动画
public enum WZPresentationAnimatedTransitionType{
    /// 自定义转场 用来继承扩展自定义动画类型的
    case custom(WZPresentationBaseAnimatedTransition.Type)
    case alertNormal
    case alertFade
    case alertDropDown
    case alertBlurEffect(WZPresentationBlurEffectStyle)
    case alertFadeBlurEffect(WZPresentationBlurEffectStyle)
    case alertDropDownBlurEffect(WZPresentationBlurEffectStyle)
    case actionSheet
    case actionSheetBlurEffect(WZPresentationBlurEffectStyle)
}

extension WZPresentationAnimatedTransitionType{
    
    public func presentationAnimatedTransition(isPresent:Bool = true) ->WZPresentationBaseAnimatedTransition {
        return animatedTransitionClase.init(isPresent: isPresent)
    }
    
    public var blurEffectType:WZPresentationBlurEffectStyle? {
        switch self {
        case .alertBlurEffect(let type), .alertFadeBlurEffect(let type),
             .alertDropDownBlurEffect(let type), .actionSheetBlurEffect(let type):
            return type
        default:
            return nil
        }
    }
    
    public var isActionSheet:Bool {
        switch self {
        case .actionSheet, .actionSheetBlurEffect(_):
            return true
        default:
            return false
        }
    }
    
    var animatedTransitionClase:WZPresentationBaseAnimatedTransition.Type{
        switch self {
        case .custom(let Class):
            return Class
        case .alertNormal,.alertBlurEffect(_):
            return HXAlertAnimatedTransition.self
        case .alertFade, .alertFadeBlurEffect(_):
            return HXAlertFadeAnimatedTransition.self
        case .alertDropDown, .alertDropDownBlurEffect(_):
            return HXAlertDropDownAnimatedTransition.self
        case .actionSheet, .actionSheetBlurEffect(_):
            return HXActionSheetAnimatedTransition.self
        }
    }
}
