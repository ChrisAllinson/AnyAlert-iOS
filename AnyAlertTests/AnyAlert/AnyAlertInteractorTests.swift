//
//  AnyAlertInteractorTests.swift
//  AnyApp
//
//  Created by Chris Allinson on 2018-01-28.
//  Copyright © 2018 Chris Allinson. All rights reserved.
//

@testable import AnyAlert


import XCTest

class AlertInteractorTests: XCTestCase {
    
    // MARK: instance variables
    
    var sut: AnyAlertInteractor!
    var alertPresenterSpy: AnyAlertPresenterSpy!
    
    
    
    // MARK: lifecycle methods
    
    override func setUp() {
        super.setUp()
        
        setupSut()
        setupSpy()
    }
    
    override func tearDown() {
        sut = nil
        alertPresenterSpy = nil
        
        super.tearDown()
    }
    
    
    
    // MARK: setup
    
    func setupSut() {
        sut = AnyAlertInteractor()
    }
    
    func setupSpy() {
        alertPresenterSpy = AnyAlertPresenterSpy()
        sut.presenter = alertPresenterSpy
    }
    
    
    
    // MARK: spies
    
    class AnyAlertPresenterSpy: AnyAlertPresentationLogic {
        
        var wasDisplayAlertCalled: Bool = false
        var displayAlertResponse: AnyAlertAction.Display.Response?
        
        var wasDismissAlertCalled: Bool = false
        var dismissAlertResponse: AnyAlertAction.Dismiss.Response?
        
        
        
        // AlertPresentationLogic
        
        func displayAlert(response: AnyAlertAction.Display.Response) {
            wasDisplayAlertCalled = true
            displayAlertResponse = response
        }
        
        func dismissAlert(response: AnyAlertAction.Dismiss.Response) {
            wasDismissAlertCalled = true
            dismissAlertResponse = response
        }
    }
    
    
    
    // MARK: tests
    
    func testDisplayAlert() {
        
        // given
        
        let tempRequest: AnyAlertAction.Display.Request = AnyAlertAction.Display.Request(
            delegate: AnyAlertManager.shared,
            id: "ABCD-EFGH",
            message: "test message",
            backgroundColor: UIColor.white,
            statusBarStyle: .default,
            messageFont: UIFont.systemFont(ofSize: 12.0),
            messageColor: UIColor.white,
            closeButtonFont: UIFont.systemFont(ofSize: 12.0),
            closeButtonColor: UIColor.white,
            openSpeed: 3.0,
            closeSpeed: 4.0,
            doesSelfDismiss: true,
            showFor: 5.0,
            hasNavBar: true,
            parentVcName: "vc name",
            initialStatusBarStyle: .lightContent,
            startPositionY: 6.0,
            endPositionY: 7.0
        )
        
        
        // when
        
        sut.displayAlert(request: tempRequest)
        
        
        // then
        
        XCTAssertTrue(alertPresenterSpy.wasDisplayAlertCalled, "Presenter displayAlert called correctly")
        
        XCTAssertTrue((alertPresenterSpy.displayAlertResponse?.id)! == "ABCD-EFGH", "id passed correctly")
        XCTAssertTrue((alertPresenterSpy.displayAlertResponse?.message)! == "test message", "message passed correctly")
        XCTAssertTrue((alertPresenterSpy.displayAlertResponse?.parentVcName)! == "vc name", "parentVcName passed correctly")
        XCTAssertTrue((alertPresenterSpy.displayAlertResponse?.initialStatusBarStyle)! == .lightContent, "initialStatusBarStyle passed correctly")
        XCTAssertTrue((alertPresenterSpy.displayAlertResponse?.doesSelfDismiss)!, "doesSelfDismiss passed correctly")
        XCTAssertTrue((alertPresenterSpy.displayAlertResponse?.hasNavBar)!, "hasNavBar passed correctly")
        XCTAssertTrue((alertPresenterSpy.displayAlertResponse?.openSpeed)! == 3.0, "openSpeed passed correctly")
        XCTAssertTrue((alertPresenterSpy.displayAlertResponse?.closeSpeed)! == 4.0, "closeSpeed passed correctly")
        XCTAssertTrue((alertPresenterSpy.displayAlertResponse?.showFor)! == 5.0, "showFor passed correctly")
        XCTAssertTrue((alertPresenterSpy.displayAlertResponse?.startPositionY)! == 6.0, "startPositionY passed correctly")
        XCTAssertTrue((alertPresenterSpy.displayAlertResponse?.endPositionY)! == 7.0, "endPositionY passed correctly")
    }
    
    func testDismissAlert() {
        
        // given
        
        let tempRequest: AnyAlertAction.Dismiss.Request = AnyAlertAction.Dismiss.Request(
            delegate: AnyAlertManager.shared,
            id: "ABCD-EFGH",
            closeSpeed: 3.0,
            hasNavBar: true,
            parentVcName: "vc name",
            initialStatusBarStyle: .lightContent,
            startPositionY: 2.0,
            immediately: true
        )
        
        
        // when
        
        sut.dismissAlert(request: tempRequest)
        
        
        // then
        
        XCTAssertTrue(alertPresenterSpy.wasDismissAlertCalled, "Presenter dismissAlert called correctly")
        
        XCTAssertTrue((alertPresenterSpy.dismissAlertResponse?.id)! == "ABCD-EFGH", "id passed correctly")
        XCTAssertTrue((alertPresenterSpy.dismissAlertResponse?.parentVcName)! == "vc name", "parentVcName passed correctly")
        XCTAssertTrue((alertPresenterSpy.dismissAlertResponse?.initialStatusBarStyle)! == .lightContent, "initialStatusBarStyle passed correctly")
        XCTAssertTrue((alertPresenterSpy.dismissAlertResponse?.hasNavBar)!, "hasNavBar passed correctly")
        XCTAssertTrue((alertPresenterSpy.dismissAlertResponse?.startPositionY)! == 2.0, "openSpeed passed correctly")
        XCTAssertTrue((alertPresenterSpy.dismissAlertResponse?.closeSpeed)! == 3.0, "closeSpeed passed correctly")
        XCTAssertTrue((alertPresenterSpy.dismissAlertResponse?.immediately)!, "immediately passed correctly")
    }
}
