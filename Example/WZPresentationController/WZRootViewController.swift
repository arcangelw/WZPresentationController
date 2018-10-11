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
        alert.maskAlpha = 0.8
        alert.passthroughViews = view.subviews
        switch sender.tag {
        case 0: alert.transitionType = .alertNormal
            break
        case 1: alert.transitionType = .alertFade
            break
        case 2: alert.transitionType = .alertDropDown
            break
        case 3: alert.transitionType = .alertFadeBlurEffect(style:.light)
            break
        default:
            break
        }
        UIApplication.shared.wz_visibleViewController?.present(alert, animated: true)
    }
    
    @IBAction func sheet(_ sender: UIButton) {
        let sheet = WZActionSheetPresentedViewController()
        sheet.dismissPresentedOnTap = true
        switch sender.tag {
        case 0: sheet.transitionType = .actionSheet
            break
        case 1: sheet.transitionType = .actionSheetBlurEffect(style:.dark)
            break
        default:
            break
        }
        UIApplication.shared.wz_visibleViewController?.present(sheet, animated: true)
        
//        let alert = UIAlertController(title: "dismiss", message: "dismiss dismiss dismiss", preferredStyle: .alert)
//        let action = UIAlertAction(title: "dismiss", style: .default) { _ in
//            self.dismiss(animated: true, completion: nil)
//        }
//        alert.addAction(action)
//        present(alert, animated: true)
    }
    
    
    @IBAction func passthroughViewsAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
}
