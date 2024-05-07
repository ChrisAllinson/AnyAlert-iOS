//
//  ViewController1.swift
//  AnyAlert
//
//  Created by Chris Allinson on 2024-04-28.
//

import UIKit

class ViewController1: UIViewController {
    
    // MARK: instance properties
    
    var statusBarStyle: UIStatusBarStyle = .darkContent
    
    // MARK: status bar
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
    
    
    // MARK: UI Events
    
    @IBAction func showAlertPressed() {
        let tempAlert: AnyAlert = AnyAlert(
            message: "Test Message Dark BG",
            backgroundColor: .purple,
            statusBarStyle: .lightContent,
            statusBarStyler: { [weak self] style in
                self?.statusBarStyle = style
                self?.setNeedsStatusBarAppearanceUpdate()
            },
            messageFont: .systemFont(ofSize: 20.0),
            messageColor: .white,
            accessibilityHint: "",
            closeButtonFont: .systemFont(ofSize: 20.0),
            closeButtonColor: .white,
            closeButtonAccessibilityLabel: "",
            closeButtonAccessibilityHint: "",
            padding: 20.0,
            openSpeed: 0.5,
            closeSpeed: 0.5,
            doesSelfDismiss: false,
            showFor: 2.0
        )
        AnyAlertManager.show(tempAlert, from: self)
    }
    
    @IBAction func showSelfDismissingAlertPressed() {
        let tempAlert: AnyAlert = AnyAlert(
            message: "Test Message Light BG",
            backgroundColor: .green,
            statusBarStyle: .darkContent,
            statusBarStyler: { [weak self] style in
                self?.statusBarStyle = style
                self?.setNeedsStatusBarAppearanceUpdate()
            },
            messageFont: .systemFont(ofSize: 20.0),
            messageColor: .black,
            closeButtonFont: .systemFont(ofSize: 20.0),
            closeButtonColor: .black,
            padding: 20.0,
            openSpeed: 0.5,
            closeSpeed: 0.5,
            doesSelfDismiss: true,
            showFor: 2.0
        )
        AnyAlertManager.show(tempAlert, from: self)
    }
}
