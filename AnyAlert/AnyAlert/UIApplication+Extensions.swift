//
//  UIApplication+Extensions.swift
//  AnyAlert
//
//  Created by Chris Allinson on 2024-05-02.
//

import UIKit

extension UIApplication {
    
    var keyWindow: UIWindow {
        UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first ?? UIWindow()
    }
    
    var safeAreaTopInsetsHeight: CGFloat {
        keyWindow.safeAreaInsets.top
    }
}
