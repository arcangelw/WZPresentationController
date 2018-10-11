//
//  UIKitExtension.swift
//
//  Created by 吴哲 on 2018/5/4.
//  Copyright © 2018年 arcangelw. All rights reserved.

import UIKit


extension UIViewController {
    
    fileprivate var _visibleViewController:UIViewController {
        var current = self
        if let presented = current.presentedViewController{
            current = presented
        }
        if let tab = current as? UITabBarController ,let selected = tab.selectedViewController {
            current = selected._visibleViewController
        }
        else if let nav = current as? UINavigationController ,let visible = nav.visibleViewController {
            current = visible._visibleViewController
        }
        return current
    }
}

extension UIApplication {
    
    public var wz_visibleViewController:UIViewController? {
        
        return wz_rootViewController?._visibleViewController
    }
    
    public var wz_rootViewController:UIViewController? {
        
        return  delegate?.window??.rootViewController
    }
    
}












