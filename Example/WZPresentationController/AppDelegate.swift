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

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let tabBarItemAppearance = UITabBarItem.appearance()
        tabBarItemAppearance.setTitleTextAttributes([.font : UIFont.boldSystemFont(ofSize: 24.0)], for: .normal)
        
        let w = UIWindow(frame: UIScreen.main.bounds)
        let tabBarController = UITabBarController()
        let objc = WZObjCHomeController()
        objc.title = "ObjC"
        let swift = WZSwiftHomeController()
        swift.title = "Swift"
        tabBarController.addChild(UINavigationController(rootViewController: objc))
        tabBarController.addChild(UINavigationController(rootViewController: swift))
        w.rootViewController = tabBarController
        w.makeKeyAndVisible()
        self.window = w
        return true
    }
    
}

