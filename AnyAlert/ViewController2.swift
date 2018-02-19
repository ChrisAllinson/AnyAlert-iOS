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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    
    // MARK: UI Events
    
    @IBAction func showAlertPressed()
    {
        let tempAlert: AnyAlert = AnyAlert(
            message: "Test Message",
            backgroundColor: .red,
            statusBarStyle: .lightContent,
            messageFont: UIFont.systemFont(ofSize: 16.0),
            messageColor: .white,
            closeButtonFont: UIFont.systemFont(ofSize: 16.0),
            closeButtonColor: .white,
            height: 95.0,
            openSpeed: 0.5,
            closeSpeed: 0.5,
            doesSelfDismiss: false,
            showFor: 2.0
        )
        AnyAlertManager.show(tempAlert, from: self)
    }
    
    @IBAction func showSelfDismissingAlertPressed()
    {
        let tempAlert: AnyAlert = AnyAlert(
            message: "Test Message",
            backgroundColor: .orange,
            statusBarStyle: .lightContent,
            messageFont: UIFont.systemFont(ofSize: 16.0),
            messageColor: .black,
            closeButtonFont: UIFont.systemFont(ofSize: 16.0),
            closeButtonColor: .black,
            height: 95.0,
            openSpeed: 0.5,
            closeSpeed: 0.5,
            doesSelfDismiss: true,
            showFor: 2.0
        )
        AnyAlertManager.show(tempAlert, from: self)
    }
    
    @IBAction func closePressed()
    {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
