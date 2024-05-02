//
//  AnyAlertManager.swift
//  AnyAlert
//
//  Created by Chris Allinson on 2018-01-20.
//  Copyright © 2018 Chris Allinson. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol AnyAlertManagerInput {
    static var shared: AnyAlertManager { get }
    static func show(_ alert: AnyAlert, from vc: UIViewController)
    static func show(_ alert: AnyAlert, from vc: UIViewController, tapHandler: @escaping (() -> Void))
}

protocol AnyAlertManagerDataStore {
    var alerts: Dictionary<String, [AnyAlertViewController]> { get set }
}

public class AnyAlertManager: NSObject, AnyAlertManagerDataStore {
    
    // MARK: AnyAlertManagerInput
    
    public static var shared: AnyAlertManager = AnyAlertManager()
    
    // MARK: AnyAlertManagerDataStore
    
    var alerts: Dictionary<String, [AnyAlertViewController]> = [:]
    
    // MARK: instance properties
    
    private var initialStatusBarStyles: Dictionary<String, UIStatusBarStyle> = [:]
    
    
    
    // MARK: lifecycle methods
    
    private override init() {}
    
    
    
    // MARK: private methods
    
    private func initialize(alert: AnyAlert, vc: UIViewController, tapHandler: (() -> Void)? = nil) {
        let vcName = vc.debugDescription
        
        if initialStatusBarStyles[vcName] == nil {
            initialStatusBarStyles[vcName] = vc.preferredStatusBarStyle
        }
        
        let anyAlertVC: AnyAlertViewController = AnyAlertViewController.initialize(
            delegate: self,
            alert: alert,
            parentVcName: vcName,
            initialStatusBarStyle: initialStatusBarStyles[vcName]!,
            hasNavBar: vc.hasNavBar,
            tapHandler: tapHandler
        )
        guard let anyAlertView = anyAlertVC.view else {
            return
        }
        
        if alerts[vcName] == nil {
            alerts[vcName] = []
        }
        alerts[vcName]!.append(anyAlertVC)
        
        vc.view.addSubview(anyAlertView)
        vc.view.addConstraints([
            NSLayoutConstraint(item: anyAlertView, attribute: .top, relatedBy: .equal, toItem: vc.view, attribute: .top, multiplier: 1, constant: 0.0),
            NSLayoutConstraint(item: anyAlertView, attribute: .leading, relatedBy: .equal, toItem: vc.view, attribute: .leading, multiplier: 1, constant: 0.0),
            NSLayoutConstraint(item: anyAlertView, attribute: .trailing, relatedBy: .equal, toItem: vc.view, attribute: .trailing, multiplier: 1, constant: 0.0),
            NSLayoutConstraint(item: anyAlertView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: CGFloat((anyAlertVC.dataStore?.height)!))
        ])
    }
}


// MARK: - AnyAlertManagerInput
extension AnyAlertManager: AnyAlertManagerInput {
    
    public static func show(_ alert: AnyAlert, from vc: UIViewController) {
        shared.initialize(alert: alert, vc: vc)
    }
    
    public static func show(_ alert: AnyAlert, from vc: UIViewController, tapHandler: @escaping (() -> Void)) {
        shared.initialize(alert: alert, vc: vc, tapHandler: tapHandler)
    }
}


// MARK: - AnyAlertDelegate
extension AnyAlertManager: AnyAlertDelegate {
    
    func popAlert(id: String, parentVcName: String) {
        if let _ = alerts[parentVcName] {
            for (index, alert) in alerts[parentVcName]!.enumerated() {
                if (alert.dataStore?.id)! == id {
                    alert.view.removeFromSuperview()
                    alerts[parentVcName]!.remove(at: index)
                    if alerts[parentVcName]!.count == 0 {
                        if let _ = initialStatusBarStyles[parentVcName] {
                            initialStatusBarStyles[parentVcName] = nil
                        }
                        alerts[parentVcName] = nil
                    }
                    return
                }
            }
        }
    }
}
