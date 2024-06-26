//
//  AnyAlertModels.swift
//  AnyAlert
//
//  Created by Chris Allinson on 2018-01-20.
//  Copyright (c) 2018 Chris Allinson. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - AnyAlert
public class AnyAlert: NSObject {
    
    // MARK: instance properties
    
    var message: String
    
    var backgroundColor: UIColor
    var statusBarStyle: UIStatusBarStyle
    var statusBarStyler: (_ style: UIStatusBarStyle) -> Void
    
    var messageFont: UIFont
    var messageColor: UIColor
    var labelAccessibilityHint: String?
    var closeButtonFont: UIFont
    var closeButtonColor: UIColor
    var closeButtonAccessibilityLabel: String?
    var closeButtonAccessibilityHint: String?
    
    var padding: Double
    var openSpeed: Double
    var closeSpeed: Double
    var doesSelfDismiss: Bool
    var showFor: Double
    
    
    
    // MARK: lifecycle methods
    
    @objc public init(message: String,
                      backgroundColor: UIColor = .darkText,
                      statusBarStyle: UIStatusBarStyle = .lightContent,
                      statusBarStyler: @escaping (_ style: UIStatusBarStyle) -> Void = {style in },
                      messageFont: UIFont = .systemFont(ofSize: 20.0),
                      messageColor: UIColor = .white,
                      accessibilityHint: String? = "",
                      closeButtonFont: UIFont = .systemFont(ofSize: 20.0),
                      closeButtonColor: UIColor = .white,
                      closeButtonAccessibilityLabel: String? = "",
                      closeButtonAccessibilityHint: String? = "",
                      padding: Double = 20.0,
                      openSpeed: Double = 0.5,
                      closeSpeed: Double = 0.5,
                      doesSelfDismiss: Bool = true,
                      showFor: Double = 2.0) {
        
        self.message = message
        
        self.backgroundColor = backgroundColor
        self.statusBarStyle = statusBarStyle
        self.statusBarStyler = statusBarStyler
        
        self.messageFont = messageFont
        self.messageColor = messageColor
        self.labelAccessibilityHint = accessibilityHint
        self.closeButtonFont = closeButtonFont
        self.closeButtonColor = closeButtonColor
        self.closeButtonAccessibilityLabel = closeButtonAccessibilityLabel
        self.closeButtonAccessibilityHint = closeButtonAccessibilityHint
        
        self.padding = padding
        self.openSpeed = openSpeed
        self.closeSpeed = closeSpeed
        self.doesSelfDismiss = doesSelfDismiss
        self.showFor = showFor
    }
}


// MARK: - AnyAlertAction
enum AnyAlertAction {
    
    // MARK: Display
    
    enum Display {
        
        struct Request {
            var delegate: AnyAlertDelegate
            
            var id: String
            var message: String
            var backgroundColor: UIColor
            var statusBarStyle: UIStatusBarStyle
            var messageFont: UIFont
            var messageColor: UIColor
            var closeButtonFont: UIFont
            var closeButtonColor: UIColor
            var openSpeed: Double
            var closeSpeed: Double
            var doesSelfDismiss: Bool
            var showFor: Double
            
            var hasNavBar: Bool
            var parentVcName: String
            var initialStatusBarStyle: UIStatusBarStyle
            var statusBarStyler: (UIStatusBarStyle) -> Void
            var startPositionY: Double
            var endPositionY: Double
        }
        
        struct Response {
            var delegate: AnyAlertDelegate
            
            var id: String
            var message: String
            var backgroundColor: UIColor
            var statusBarStyle: UIStatusBarStyle
            var messageFont: UIFont
            var messageColor: UIColor
            var closeButtonFont: UIFont
            var closeButtonColor: UIColor
            var openSpeed: Double
            var closeSpeed: Double
            var doesSelfDismiss: Bool
            var showFor: Double
            
            var hasNavBar: Bool
            var parentVcName: String
            var initialStatusBarStyle: UIStatusBarStyle
            var statusBarStyler: (UIStatusBarStyle) -> Void
            var startPositionY: Double
            var endPositionY: Double
        }
        
        struct ViewModel {
            var message: String
            var backgroundColor: UIColor
            var statusBarStyle: UIStatusBarStyle
            var messageFont: UIFont
            var messageColor: UIColor
            var closeButtonFont: UIFont
            var closeButtonColor: UIColor
            var openSpeed: Double
            var closeSpeed: Double
            
            var shouldHideCloseButton: Bool
            var endPositionY: Double
        }
    }
    
    // MARK: Dismiss
    
    enum Dismiss {
        
        struct Request {
            var delegate: AnyAlertDelegate
            
            var id: String
            var closeSpeed: Double
            
            var hasNavBar: Bool
            var parentVcName: String
            var initialStatusBarStyle: UIStatusBarStyle
            var startPositionY: Double
            
            var immediately: Bool?
        }
        
        struct Response {
            var delegate: AnyAlertDelegate
            
            var id: String
            var closeSpeed: Double
            
            var hasNavBar: Bool
            var parentVcName: String
            var initialStatusBarStyle: UIStatusBarStyle
            var startPositionY: Double
            
            var immediately: Bool?
        }
        
        struct ViewModel {
            var closeSpeed: Double
            
            var startPositionY: Double
            
            var immediately: Bool?
        }
    }
}
