//
//  ViewController1.swift
//  AnyAlert
//
//  Created by Chris Allinson on 2024-04-28.
//

import UIKit

class ViewController1: UIViewController {
    
    // MARK: status bar
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    
    
    // MARK: UI Events
    
    @IBAction func showAlertPressed() {
        let tempAlert: AnyAlert = AnyAlert(
            message: "Test Message Dark",
            backgroundColor: .purple,
            statusBarStyle: .lightContent,
            messageFont: .systemFont(ofSize: 20.0),
            messageColor: .white,
            closeButtonFont: .systemFont(ofSize: 20.0),
            closeButtonColor: .white,
            height: 95.0,
            openSpeed: 0.5,
            closeSpeed: 0.5,
            doesSelfDismiss: false,
            showFor: 2.0
        )
        AnyAlertManager.show(tempAlert, from: self)
    }
    
    @IBAction func showSelfDismissingAlertPressed() {
        let tempAlert: AnyAlert = AnyAlert(
            message: "Test Message Light",
            backgroundColor: .green,
            statusBarStyle: .darkContent,
            messageFont: .systemFont(ofSize: 20.0),
            messageColor: .black,
            closeButtonFont: .systemFont(ofSize: 20.0),
            closeButtonColor: .black,
            height: 95.0,
            openSpeed: 0.5,
            closeSpeed: 0.5,
            doesSelfDismiss: true,
            showFor: 2.0
        )
        AnyAlertManager.show(tempAlert, from: self)
    }
}
