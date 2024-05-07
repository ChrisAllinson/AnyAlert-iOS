//
//  UIAccessibility+Extensions.swift
//  AnyAlert
//
//  Created by Chris Allinson on 2024-05-04.
//

import UIKit

extension UIAccessibility {
    
    static func setFocusTo(_ object: Any?) {
        guard UIAccessibility.isVoiceOverRunning else {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            UIAccessibility.post(notification: .layoutChanged, argument: object)
        }
    }
}
