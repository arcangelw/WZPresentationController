//
//  AppDelegate.swift
//  WZPresentationController
//
//  Created by arcangelw on 04/28/2018.
//  Copyright (c) 2018 arcangelw. All rights reserved.
//

import UIKit
import WZPresentationController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }
}

extension UIApplication {
    ///获取当前控制器
    var currentViewController:UIViewController?{
        var vc:UIViewController? = self.delegate?.window??.rootViewController
        while vc?.presentedViewController != nil {
            vc = vc?.presentedViewController
            if vc is UINavigationController {
                vc = ( vc as! UINavigationController).visibleViewController
            }else if vc is UITabBarController {
                vc = (vc as! UITabBarController).selectedViewController
            }
        }
        
        var last:UIViewController? = nil
        repeat{
            last = vc
            if vc is UINavigationController {
                vc = ( vc as! UINavigationController).visibleViewController
            }else if vc is UITabBarController {
                vc = (vc as! UITabBarController).selectedViewController
            }
        }while(last != vc)
        
        return vc
    }
}

