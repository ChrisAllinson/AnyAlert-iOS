//
//  ViewController.swift
//  AnyAlert
//
//  Created by Chris Allinson on 2018-02-17.
//  Copyright © 2018 Chris Allinson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: lifecycle methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = .default
    }
    
    
    
    // MARK: UI Events
    
    @IBAction func showAlertPressed() {
        let tempAlert: AnyAlert = AnyAlert(
            message: "Test Message",
            backgroundColor: .green,
            statusBarStyle: .default,
            messageFont: .systemFont(ofSize: 16.0),
            messageColor: .black,
            closeButtonFont: .systemFont(ofSize: 16.0),
            closeButtonColor: .black,
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
            message: "Test Message",
            backgroundColor: .purple,
            statusBarStyle: .lightContent,
            messageFont: .systemFont(ofSize: 16.0),
            messageColor: .white,
            closeButtonFont: .systemFont(ofSize: 16.0),
            closeButtonColor: .white,
            height: 95.0,
            openSpeed: 0.5,
            closeSpeed: 0.5,
            doesSelfDismiss: true,
            showFor: 2.0
        )
        AnyAlertManager.show(tempAlert, from: self)
    }
}
