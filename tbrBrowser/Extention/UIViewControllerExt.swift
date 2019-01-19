//
//  UIViewControllerExt.swift
//  tbrBrowser
//
//  Created by 喻建军 on 2018/12/12.
//  Copyright © 2018 Jianjun Yu. All rights reserved.
//

import UIKit
import MBProgressHUD

extension UIViewController {
    
    func showMBText(message: String) {
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = .text
        hud.label.text = message
        hud.offset = CGPoint(x: 0, y: MBProgressMaxOffset)
        hud.hide(animated: true, afterDelay: 3)
    }

}
