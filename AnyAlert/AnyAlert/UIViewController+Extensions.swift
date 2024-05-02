//
//  UIViewController+Extensions.swift
//  AnyAlert
//
//  Created by Chris Allinson on 2024-05-01.
//

import UIKit

extension UIViewController {
    
    var hasNavBar: Bool {
        if let navController = self.navigationController {
            return !navController.isNavigationBarHidden
        }
        return false
    }
}
