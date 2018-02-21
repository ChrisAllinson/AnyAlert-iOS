//
//  AnyAlertManager.swift
//  AnyApp
//
//  Created by Chris Allinson on 2018-01-20.
//  Copyright © 2018 Chris Allinson. All rights reserved.
//

import Foundation
import UIKit


protocol AnyAlertManagerDataStore
{
    var alerts: Dictionary<String, [AnyAlertViewController]> { get set }
}

@objc
protocol AnyAlertManagerInput
{
    static func show(_ alert: AnyAlert, from vc: UIViewController)
    static func show(_ alert: AnyAlert, from vc: UIViewController, tapHandler: @escaping (() -> Void))
}


// MARK: -

public class AnyAlertManager: NSObject, AnyAlertManagerDataStore
{
    // MARK: Singleton instance variables
    
    static var shared: AnyAlertManager = AnyAlertManager()
    
    
    
    // MARK: AnyAlertManagerDataStore
    
    var alerts: Dictionary<String, [AnyAlertViewController]> = [:]
    var initialStatusBarStyles: Dictionary<String, UIStatusBarStyle> = [:]
    
    
    
    // MARK: Fileprivate methods
    
    fileprivate func initCustom(alert: AnyAlert, vc: UIViewController, tapHandler: (() -> Void)? = nil)
    {
        let vcName = vc.debugDescription
        
        if initialStatusBarStyles[vcName] == nil {
            initialStatusBarStyles[vcName] = UIApplication.shared.statusBarStyle
        }
        
        let hasNavBar: Bool = vcHasNavBar(vc)
        
        let tempVC: AnyAlertViewController = AnyAlertViewController.init(
            delegate: self,
            alert: alert,
            parentVcName: vcName,
            initialStatusBarStyle: initialStatusBarStyles[vcName]!,
            hasNavBar: hasNavBar,
            tapHandler: tapHandler
        )
        
        if alerts[vcName] == nil {
            alerts[vcName] = []
        }
        alerts[vcName]!.append(tempVC)

        
        vc.view.addSubview(tempVC.view)
        
        vc.view.addConstraints([
            NSLayoutConstraint(
                item: tempVC.view,
                attribute: .top,
                relatedBy: .equal,
                toItem: vc.view,
                attribute: .top,
                multiplier: 1,
                constant: 0.0
            ),
            NSLayoutConstraint(
                item: tempVC.view,
                attribute: .leading,
                relatedBy: .equal,
                toItem: vc.view,
                attribute: .leading,
                multiplier: 1,
                constant: 0.0
            ),
            NSLayoutConstraint(
                item: tempVC.view,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: vc.view,
                attribute: .trailing,
                multiplier: 1,
                constant: 0.0
            ),
            NSLayoutConstraint(
                item: tempVC.view,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .height,
                multiplier: 1,
                constant: CGFloat((tempVC.dataStore?.height)!)
            )
        ])
    }
    
    fileprivate func vcHasNavBar(_ vc: UIViewController) -> Bool
    {
        if let _ = vc.navigationController {
            let isNavBarHidden: Bool = (vc.navigationController?.isNavigationBarHidden)!
            return !isNavBarHidden
        }
        return false
    }
}


// MARK: -

extension AnyAlertManager: AnyAlertManagerInput
{
    // MARK: AnyAlertManagerInput
    
    public static func show(_ alert: AnyAlert, from vc: UIViewController)
    {
        shared.initCustom(alert: alert, vc: vc)
    }
    
    public static func show(_ alert: AnyAlert, from vc: UIViewController, tapHandler: @escaping (() -> Void))
    {
        shared.initCustom(alert: alert, vc: vc, tapHandler: tapHandler)
    }
}


// MARK: -

extension AnyAlertManager: AnyAlertDelegate
{
    // MARK: AnyAlertDelegate
    
    func popAlert(id: String, parentVcName: String)
    {
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
