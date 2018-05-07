//
//  WZAlertPresentedViewController.swift
//  WZPresentationController_Example
//
//  Created by 吴哲 on 2018/5/4.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import WZPresentationController

class WZAlertPresentedViewController: WZPresentedViewController {
    
    let dismissButton:UIButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        dismissButton.setTitle("dismiss", for: .normal)
        dismissButton.setTitleColor(.white, for: .normal)
        dismissButton.backgroundColor = .blue
        view.addSubview(dismissButton)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[dismissButton(120)]", options:[], metrics: nil, views: ["dismissButton":dismissButton]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[dismissButton(40)]", options:[], metrics: nil, views: ["dismissButton":dismissButton]))
        view.addConstraint(NSLayoutConstraint(item: dismissButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: dismissButton, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        dismissButton.addTarget(self, action: #selector(self.dismissClick), for: .touchUpInside)
        preferredContentSize = CGSize(width: 200, height: 150.0)
    }
    
    @objc func dismissClick(){
        dismiss(animated: true, completion: nil)
    }

}
