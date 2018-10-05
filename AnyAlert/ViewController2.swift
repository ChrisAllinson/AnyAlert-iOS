//
//  ViewController2.swift
//  AnyAlert
//
//  Created by Chris Allinson on 2018-02-17.
//  Copyright © 2018 Chris Allinson. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {
    
    // MARK: Lifecycle methods
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    
    
    // MARK: UI Events
    
    @IBAction func showAlertPressed() {
        let tempAlert: AnyAlert = AnyAlert(
            message: "Test Message",
            backgroundColor: .red,
            statusBarStyle: .lightContent,
            messageFont: .systemFont(ofSize: 16.0),
            messageColor: .white,
            closeButtonFont: .systemFont(ofSize: 16.0),
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
            message: "Test Message",
            backgroundColor: .orange,
            statusBarStyle: .lightContent,
            messageFont: .systemFont(ofSize: 16.0),
            messageColor: .black,
            closeButtonFont: .systemFont(ofSize: 16.0),
            closeButtonColor: .black,
            height: 95.0,
            openSpeed: 0.5,
            closeSpeed: 0.5,
            doesSelfDismiss: true,
            showFor: 2.0
        )
        AnyAlertManager.show(tempAlert, from: self)
    }
    
    @IBAction func closePressed() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}
