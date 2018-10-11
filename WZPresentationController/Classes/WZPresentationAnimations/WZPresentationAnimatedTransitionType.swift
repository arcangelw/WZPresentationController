//
//  WZPresentationAnimatedTransition.swift
//
//  Created by 吴哲 on 2018/5/3.
//  Copyright © 2018年 arcangelw. All rights reserved.
//  转场类型

import UIKit


/// 基本转场动画
public enum WZPresentationAnimatedTransitionType{
    /// 自定义转场 用来继承扩展自定义动画类型的
    case custom(WZPresentationBaseAnimatedTransition.Type)
    case alertNormal
    case alertFade
    case alertDropDown
    case alertBlurEffect(style:UIBlurEffect.Style)
    case alertFadeBlurEffect(style:UIBlurEffect.Style)
    case alertDropDownBlurEffect(style:UIBlurEffect.Style)
    case actionSheet
    case actionSheetBlurEffect(style:UIBlurEffect.Style)
}

extension WZPresentationAnimatedTransitionType{
    
    public func presentationAnimatedTransition(isPresent:Bool = true) ->WZPresentationBaseAnimatedTransition {
        return animatedTransitionClase.init(isPresent: isPresent)
    }
    
    public var blurEffect:UIBlurEffect? {
        switch self {
        case let .alertBlurEffect(value), let .alertFadeBlurEffect(value), let .alertDropDownBlurEffect(value), let .actionSheetBlurEffect(value): return UIBlurEffect(style: value)
        default: return nil
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
        case let .custom(Class):
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
