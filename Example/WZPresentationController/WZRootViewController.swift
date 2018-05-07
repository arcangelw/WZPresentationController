//
//  WZRootViewController.swift
//  WZPresentationController_Example
//
//  Created by 吴哲 on 2018/5/4.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit

class WZRootViewController: UIViewController {
    
    @IBAction func Alert(_ sender: UIButton) {
        let alert = WZAlertPresentedViewController()
        alert.dismissPresentedOnTap = true
        alert.passthroughViews = view.subviews
        switch sender.tag {
        case 0: alert.transitionType = .alertNormal
            break
        case 1: alert.transitionType = .alertFade
            break
        case 2: alert.transitionType = .alertDropDown
            break
        case 3: alert.transitionType = .alertFadeBlurEffect(.light)
            break
        default:
            break
        }
        UIApplication.shared.currentViewController?.present(alert, animated: true) {
        }
    }
    
    @IBAction func sheet(_ sender: UIButton) {
        let sheet = WZActionSheetPresentedViewController()
        sheet.dismissPresentedOnTap = true
        switch sender.tag {
        case 0: sheet.transitionType = .actionSheet
            break
        case 1: sheet.transitionType = .actionSheetBlurEffect(.dark)
            break
        default:
            break
        }
        UIApplication.shared.currentViewController?.present(sheet, animated: true) {
        }
    }
    
    
    @IBAction func passthroughViewsAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    
}
