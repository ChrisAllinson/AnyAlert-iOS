//
//  AnyAlertManagerTests.swift
//  AnyApp
//
//  Created by Chris Allinson on 2018-01-28.
//  Copyright © 2018 Chris Allinson. All rights reserved.
//

@testable import AnyAlert


import XCTest
import UIKit

class AnyAlertManagerTests: XCTestCase {
    
    // MARK: instance variables
    
    var sut: AnyAlertManager!
    var window: UIWindow!
    var vc: UIViewController!
    var vcName: String!
    
    
    
    // MARK: lifecycle methods
    
    override func setUp() {
        super.setUp()
        
        setupSut()
        setupWindow()
    }
    
    override func tearDown() {
        sut = nil
        window = nil
        vc = nil
        vcName = nil
        
        super.tearDown()
    }
    
    
    
    // MARK: Setup
    
    func setupSut() {
        sut = AnyAlertManager.shared
        sut.alerts = [:]
    }
    
    func setupWindow() {
        window = UIWindow()
        vc = UIViewController()
        window.rootViewController = vc
        window.makeKeyAndVisible()
        
        vcName = vc.debugDescription
    }
    
    
    
    // MARK: tests
    
    func testShow() {
        
        // given
        
        let tempAlert: AnyAlert = AnyAlert(
            message: "Test Message",
            backgroundColor: UIColor.yellow,
            statusBarStyle: .lightContent,
            messageFont: UIFont.systemFont(ofSize: 12.0),
            messageColor: UIColor.orange,
            closeButtonFont: UIFont.systemFont(ofSize: 12.0),
            closeButtonColor: UIColor.red,
            height: 200,
            openSpeed: 1.0,
            closeSpeed: 2.0,
            doesSelfDismiss: true,
            showFor: 3.0
        )
        
        
        // when
        
        AnyAlertManager.show(tempAlert, from: vc)
        
        let tempAlert2: AnyAlertViewController = (sut.alerts[vcName]?.last)!
        tempAlert2.viewDidAppear(false)
        
        
        // then
        
        XCTAssertTrue((sut.alerts[vcName]?.count)! == 1, "Alert added to alerts array correctly")
        
        XCTAssertTrue((window.rootViewController?.view.subviews[0])! == tempAlert2.view, "Alert view added to window correctly")
        
        XCTAssertNil(tempAlert2.dataStore?.tapHandler, "tapHandler not set correctly")
    }
    
    func testShow_WithTapHandler() {
        
        // given
        
        let tempAlert: AnyAlert = AnyAlert(
            message: "Test Message",
            backgroundColor: UIColor.yellow,
            statusBarStyle: .lightContent,
            messageFont: UIFont.systemFont(ofSize: 12.0),
            messageColor: UIColor.orange,
            closeButtonFont: UIFont.systemFont(ofSize: 12.0),
            closeButtonColor: UIColor.red,
            height: 200,
            openSpeed: 1.0,
            closeSpeed: 2.0,
            doesSelfDismiss: true,
            showFor: 3.0
        )
        
        
        // when
        
        AnyAlertManager.show(tempAlert, from: vc, tapHandler: { 
            // no op
        })
        
        let tempAlert2: AnyAlertViewController = (sut.alerts[vcName]?.last)!
        tempAlert2.viewDidAppear(false)
        
        
        // then
        
        XCTAssertTrue((sut.alerts[vcName]?.count)! == 1, "Alert added to alerts array correctly")
        
        XCTAssertTrue((window.rootViewController?.view.subviews[0])! == tempAlert2.view, "Alert view added to window correctly")
        
        XCTAssertNotNil(tempAlert2.dataStore?.tapHandler, "tapHandler set correctly")
    }
    
    func testPopAlert() {
        
        // given
        
        let tempAlert1: AnyAlert = AnyAlert(
            message: "Test Message",
            backgroundColor: UIColor.orange,
            statusBarStyle: .default,
            messageFont: UIFont.systemFont(ofSize: 12.0),
            messageColor: UIColor.purple,
            closeButtonFont: UIFont.systemFont(ofSize: 12.0),
            closeButtonColor: UIColor.purple,
            height: 200,
            openSpeed: 1.0,
            closeSpeed: 2.0,
            doesSelfDismiss: false,
            showFor: 3.0
        )
        AnyAlertManager.show(tempAlert1, from: vc)
        
        let tempAlert2: AnyAlert = AnyAlert(
            message: "Message",
            backgroundColor: UIColor.orange,
            statusBarStyle: .default,
            messageFont: UIFont.systemFont(ofSize: 12.0),
            messageColor: UIColor.purple,
            closeButtonFont: UIFont.systemFont(ofSize: 12.0),
            closeButtonColor: UIColor.purple,
            height: 100,
            openSpeed: 0.5,
            closeSpeed: 0.5,
            doesSelfDismiss: false,
            showFor: 1.0
        )
        AnyAlertManager.show(tempAlert2, from: vc)
        
        let tempAlert3: AnyAlert = AnyAlert(
            message: "Message",
            backgroundColor: UIColor.orange,
            statusBarStyle: .default,
            messageFont: UIFont.systemFont(ofSize: 12.0),
            messageColor: UIColor.purple,
            closeButtonFont: UIFont.systemFont(ofSize: 12.0),
            closeButtonColor: UIColor.purple,
            height: 100,
            openSpeed: 0.5,
            closeSpeed: 0.5,
            doesSelfDismiss: false,
            showFor: 1.0
        )
        AnyAlertManager.show(tempAlert3, from: vc)
        
        let alertToPop: AnyAlertViewController = (sut.alerts[vcName]?.last)!
        let alertToPopId: String = (alertToPop.dataStore?.id)!
        
        
        // when
        
        sut.popAlert(id: alertToPopId, parentVcName: vcName)
        
        let tempAlert4: AnyAlertViewController = (sut.alerts[vcName]?.last)!
        tempAlert4.viewDidAppear(false)
        
        
        // then
        
        XCTAssertTrue((sut.alerts[vcName]?.count)! == 2, "Alert removed from alerts array correctly")
        
        XCTAssertTrue((window.rootViewController?.view.subviews[1])! == tempAlert4.view, "Alert view added to window correctly")
    }
    
    func testPopAlert_DeleteKey() {
        
        // given
        
        let tempAlert: AnyAlert = AnyAlert(
            message: "Test Message",
            backgroundColor: UIColor.white,
            statusBarStyle: .default,
            messageFont: UIFont.systemFont(ofSize: 12.0),
            messageColor: UIColor.white,
            closeButtonFont: UIFont.systemFont(ofSize: 12.0),
            closeButtonColor: UIColor.white,
            height: 100.0,
            openSpeed: 0.5,
            closeSpeed: 0.5,
            doesSelfDismiss: false,
            showFor: 1.0
        )
        AnyAlertManager.show(tempAlert, from: vc)
        
        let alertToPop: AnyAlertViewController = (sut.alerts[vcName]?.last)!
        let alertToPopId: String = (alertToPop.dataStore?.id)!
        
        
        // when
        
        sut.popAlert(id: alertToPopId, parentVcName: vcName)
        
        
        // then
        
        XCTAssertNil(sut.alerts[vcName], "Key deleted from dictionary correctly")
    }
}
