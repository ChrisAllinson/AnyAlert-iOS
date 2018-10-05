//
//  AnyAlertPresenterTests.swift
//  AnyApp
//
//  Created by Chris Allinson on 2018-01-28.
//  Copyright © 2018 Chris Allinson. All rights reserved.
//

@testable import AnyAlert


import XCTest

class AnyAlertPresenterTests: XCTestCase {
    
    // MARK: instance variables
    
    var window: UIWindow!
    var vc: UIViewController!
    var vcName: String!
    var navController: UINavigationController!
    
    var sut: AnyAlertPresenter!
    var viewControllerSpy: AnyAlertViewControllerSpy!
    
    
    
    // MARK: lifecycle methods
    
    override func setUp() {
        super.setUp()
        
        setupSut()
        setupSpy()
    }
    
    override func tearDown() {
        window = nil
        vc = nil
        vcName = nil
        navController = nil
        
        sut = nil
        viewControllerSpy = nil
        
        AnyAlertManager.shared.alerts = [:]
        
        super.tearDown()
    }
    
    
    
    // MARK: setup
    
    func setupViewController() {
        vc = UIViewController()
        vcName = vc.debugDescription
        
        window = UIWindow()
        window.rootViewController = vc
        window.makeKeyAndVisible()
    }
    
    func setupNavController() {
        vc = UIViewController()
        vcName = vc.debugDescription
        
        navController = UINavigationController.init(rootViewController: vc)
        
        window = UIWindow()
        window.rootViewController = navController
        window.makeKeyAndVisible()
    }
    
    func setupSut() {
        sut = AnyAlertPresenter()
    }
    
    func setupSpy() {
        viewControllerSpy = AnyAlertViewControllerSpy()
        sut.viewController = viewControllerSpy
    }
    
    
    
    // MARK: spies
    
    class AnyAlertViewControllerSpy: AnyAlertDisplayLogic {
        
        var wasSetStyleCalled: Bool = false
        var backgroundColor: UIColor?
        var messageFont: UIFont?
        var messageColor: UIColor?
        var closeButtonFont: UIFont?
        var closeButtonColor: UIColor?
        
        var wasSetMessageCalled: Bool = false
        var message: String?
        
        var wasSetCloseButtonVisibilityCalled: Bool = false
        var shouldHideCloseButton: Bool?
        
        var wasSetStatusBarStyleCalled: Bool = false
        var statusBarStyle: UIStatusBarStyle?
        
        var wasShowAlertCalled: Bool = false
        var openSpeed: Double?
        
        var wasHideAlertCalled: Bool = false
        var closeSpeed: Double?
        var immediately: Bool!
        
        
        
        // AlertDisplayLogic
        
        func setStyle(viewModel: AnyAlertAction.Display.ViewModel) {
            wasSetStyleCalled = true
            backgroundColor = viewModel.backgroundColor
            messageFont = viewModel.messageFont
            messageColor = viewModel.messageColor
            closeButtonFont = viewModel.closeButtonFont
            closeButtonColor = viewModel.closeButtonColor
        }
        
        func setMessage(viewModel: AnyAlertAction.Display.ViewModel) {
            wasSetMessageCalled = true
            message = viewModel.message
        }
        
        func setCloseButtonVisibility(viewModel: AnyAlertAction.Display.ViewModel) {
            wasSetCloseButtonVisibilityCalled = true
            shouldHideCloseButton = viewModel.shouldHideCloseButton
        }
        
        func setStatusBarStyle(viewModel: AnyAlertAction.Display.ViewModel) {
            wasSetStatusBarStyleCalled = true
            statusBarStyle = viewModel.statusBarStyle
        }
        
        func showAlert(viewModel: AnyAlertAction.Display.ViewModel) {
            wasShowAlertCalled = true
            openSpeed = viewModel.openSpeed
        }
        
        func hideAlert(viewModel: AnyAlertAction.Dismiss.ViewModel) {
            wasHideAlertCalled = true
            closeSpeed = viewModel.closeSpeed
            immediately = viewModel.immediately
        }
    }
    
    
    
    // MARK: tests
    
    // MARK: Display
    
    func testDisplayAlert() {
        
        // given
        
        let tempResponse: AnyAlertAction.Display.Response = AnyAlertAction.Display.Response(
            delegate: AnyAlertManager.shared,
            id: "",
            message: "test message",
            backgroundColor: .yellow,
            statusBarStyle: .lightContent,
            messageFont: UIFont.systemFont(ofSize: 12.0),
            messageColor: .orange,
            closeButtonFont: UIFont.systemFont(ofSize: 12.0),
            closeButtonColor: .red,
            openSpeed: 0.5,
            closeSpeed: 0.5,
            doesSelfDismiss: false,
            showFor: 1.0,
            hasNavBar: false,
            parentVcName: "",
            initialStatusBarStyle: .default,
            startPositionY: -126.0,
            endPositionY: -26.0
        )
        
        
        // when
        
        sut.displayAlert(response: tempResponse)
        
        
        // then
        
        XCTAssertTrue(viewControllerSpy.wasSetStyleCalled, "setStyle() called correctly")
        XCTAssertTrue(viewControllerSpy.backgroundColor == .yellow, "backgroundColor set correctly")
        XCTAssertTrue(viewControllerSpy.messageFont == UIFont.systemFont(ofSize: 12.0), "messageFont set correctly")
        XCTAssertTrue(viewControllerSpy.messageColor == .orange, "messageColor set correctly")
        XCTAssertTrue(viewControllerSpy.closeButtonFont == UIFont.systemFont(ofSize: 12.0), "closeButtonFont set correctly")
        XCTAssertTrue(viewControllerSpy.closeButtonColor == .red, "closeButtonColor set correctly")
        
        XCTAssertTrue(viewControllerSpy.wasSetMessageCalled, "setMessage() called correctly")
        XCTAssertTrue(viewControllerSpy.message == "test message", "message passed correctly")
        
        XCTAssertTrue(viewControllerSpy.wasSetCloseButtonVisibilityCalled, "setCloseButtonVisibility() called correctly")
        
        XCTAssertTrue(viewControllerSpy.wasShowAlertCalled, "showAlert() called correctly")
        XCTAssertTrue(viewControllerSpy.openSpeed == 0.5, "openSpeed set correctly")
        
        XCTAssertFalse(viewControllerSpy.wasSetStatusBarStyleCalled, "setStatusBarStyle() not called yet correctly")
        
        let exp = expectation(description: "Await show/hide alert")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            exp.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(viewControllerSpy.wasSetStatusBarStyleCalled, "setStatusBarStyle() not called correctly")
        XCTAssertTrue(viewControllerSpy.statusBarStyle == .lightContent, "statusBarStyle set correctly")
        
        XCTAssertFalse(viewControllerSpy.wasHideAlertCalled, "hideAlert() not called correctly")
    }
    
    func testDisplayAlert_NavBar() {
        
        // given
        
        let tempResponse: AnyAlertAction.Display.Response = AnyAlertAction.Display.Response(
            delegate: AnyAlertManager.shared,
            id: "",
            message: "test message",
            backgroundColor: .red,
            statusBarStyle: .default,
            messageFont: UIFont.systemFont(ofSize: 12.0),
            messageColor: .purple,
            closeButtonFont: UIFont.systemFont(ofSize: 12.0),
            closeButtonColor: .blue,
            openSpeed: 0.5,
            closeSpeed: 0.5,
            doesSelfDismiss: false,
            showFor: 1.0,
            hasNavBar: true,
            parentVcName: "",
            initialStatusBarStyle: .default,
            startPositionY: -126.0,
            endPositionY: -26.0
        )
        
        
        // when
        
        sut.displayAlert(response: tempResponse)
        
        
        // then
        
        XCTAssertTrue(viewControllerSpy.wasSetStyleCalled, "setStyle() called correctly")
        XCTAssertTrue(viewControllerSpy.backgroundColor == .red, "backgroundColor set correctly")
        XCTAssertTrue(viewControllerSpy.messageFont == UIFont.systemFont(ofSize: 12.0), "messageFont set correctly")
        XCTAssertTrue(viewControllerSpy.messageColor == .purple, "messageColor set correctly")
        XCTAssertTrue(viewControllerSpy.closeButtonFont == UIFont.systemFont(ofSize: 12.0), "closeButtonFont set correctly")
        XCTAssertTrue(viewControllerSpy.closeButtonColor == .blue, "closeButtonColor set correctly")
        
        XCTAssertTrue(viewControllerSpy.wasSetMessageCalled, "setMessage() called correctly")
        XCTAssertTrue(viewControllerSpy.message == "test message", "message passed correctly")
        
        XCTAssertTrue(viewControllerSpy.wasSetCloseButtonVisibilityCalled, "setCloseButtonVisibility() called correctly")
        
        XCTAssertTrue(viewControllerSpy.wasShowAlertCalled, "showAlert() called correctly")
        XCTAssertTrue(viewControllerSpy.openSpeed == 0.5, "openSpeed set correctly")
        
        XCTAssertFalse(viewControllerSpy.wasSetStatusBarStyleCalled, "setStatusBarStyle() not called yet correctly")
        
        let exp = expectation(description: "Await show/hide alert")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            exp.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertFalse(viewControllerSpy.wasSetStatusBarStyleCalled, "setStatusBarStyle() not called correctly")
        
        XCTAssertFalse(viewControllerSpy.wasHideAlertCalled, "hideAlert() not called correctly")
    }
    
    func testDisplayAlert_SelfDismiss() {
        
        // given
        
        let tempResponse: AnyAlertAction.Display.Response = AnyAlertAction.Display.Response(
            delegate: AnyAlertManager.shared,
            id: "",
            message: "test message",
            backgroundColor: UIColor.white,
            statusBarStyle: .default,
            messageFont: UIFont.systemFont(ofSize: 12.0),
            messageColor: UIColor.white,
            closeButtonFont: UIFont.systemFont(ofSize: 12.0),
            closeButtonColor: UIColor.white,
            openSpeed: 0.5,
            closeSpeed: 0.5,
            doesSelfDismiss: true,
            showFor: 1.0,
            hasNavBar: false,
            parentVcName: "",
            initialStatusBarStyle: .default,
            startPositionY: -126.0,
            endPositionY: -26.0
        )
        
        
        // when
        
        sut.displayAlert(response: tempResponse)
        
        
        // then
        
        XCTAssertTrue(viewControllerSpy.wasSetStyleCalled, "setStyle() called correctly")
        XCTAssertTrue(viewControllerSpy.wasSetMessageCalled, "setMessage() called correctly")
        XCTAssertTrue(viewControllerSpy.wasSetCloseButtonVisibilityCalled, "setCloseButtonVisibility() called correctly")
        XCTAssertTrue(viewControllerSpy.wasShowAlertCalled, "showAlert() called correctly")
        XCTAssertFalse(viewControllerSpy.wasHideAlertCalled, "hideAlert() not called yet correctly")
        
        let exp = expectation(description: "Await show/hide alert")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            exp.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(viewControllerSpy.wasSetStatusBarStyleCalled, "setStatusBarStyle() called correctly")
        XCTAssertTrue(viewControllerSpy.wasHideAlertCalled, "hideAlert() called correctly")
        XCTAssertTrue(viewControllerSpy.closeSpeed == 0.5, "closeSpeed set correctly")
    }
    
    func testDisplayAlert_SelfDismiss_NavBar() {
        
        // given
        
        let tempResponse: AnyAlertAction.Display.Response = AnyAlertAction.Display.Response(
            delegate: AnyAlertManager.shared,
            id: "",
            message: "test message",
            backgroundColor: UIColor.white,
            statusBarStyle: .default,
            messageFont: UIFont.systemFont(ofSize: 12.0),
            messageColor: UIColor.white,
            closeButtonFont: UIFont.systemFont(ofSize: 12.0),
            closeButtonColor: UIColor.white,
            openSpeed: 0.5,
            closeSpeed: 0.5,
            doesSelfDismiss: true,
            showFor: 1.0,
            hasNavBar: true,
            parentVcName: "",
            initialStatusBarStyle: .lightContent,
            startPositionY: -126.0,
            endPositionY: -26.0
        )
        
        
        // when
        
        sut.displayAlert(response: tempResponse)
        
        
        // then
        
        XCTAssertTrue(viewControllerSpy.wasSetStyleCalled, "setStyle() called correctly")
        XCTAssertTrue(viewControllerSpy.wasSetMessageCalled, "setMessage() called correctly")
        XCTAssertTrue(viewControllerSpy.wasSetCloseButtonVisibilityCalled, "setCloseButtonVisibility() called correctly")
        XCTAssertTrue(viewControllerSpy.wasShowAlertCalled, "showAlert() called correctly")
        XCTAssertFalse(viewControllerSpy.wasHideAlertCalled, "hideAlert() not called yet correctly")
        
        let exp = expectation(description: "Await show/hide alert")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            exp.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertFalse(viewControllerSpy.wasSetStatusBarStyleCalled, "setStatusBarStyle() not called correctly")
        XCTAssertTrue(viewControllerSpy.wasHideAlertCalled, "hideAlert() not called correctly")
        XCTAssertTrue(viewControllerSpy.closeSpeed == 0.5, "closeSpeed set correctly")
    }
    
    
    // MARK: Dismiss
    
    func testDismissAlert_HideAlertCalled() {
        
        // given
        
        let tempResponse: AnyAlertAction.Dismiss.Response = AnyAlertAction.Dismiss.Response(
            delegate: AnyAlertManager.shared,
            id: "",
            closeSpeed: 0.5,
            hasNavBar: false,
            parentVcName: "",
            initialStatusBarStyle: .default,
            startPositionY: -26.0,
            immediately: false
        )
        
        
        // when
        
        sut.dismissAlert(response: tempResponse)
        
        let exp = expectation(description: "Await hide alert")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            exp.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        
        // then
        
        XCTAssertTrue(viewControllerSpy.wasHideAlertCalled, "hideAlert() called correctly")
        XCTAssertFalse(viewControllerSpy.immediately, "immediately passed correctly")
    }
    
    func testDismissAlert_HideAlertCalled_Immediately() {
        
        // given
        
        let tempResponse: AnyAlertAction.Dismiss.Response = AnyAlertAction.Dismiss.Response(
            delegate: AnyAlertManager.shared,
            id: "",
            closeSpeed: 0.5,
            hasNavBar: false,
            parentVcName: "",
            initialStatusBarStyle: .default,
            startPositionY: -26.0,
            immediately: true
        )
        
        
        // when
        
        sut.dismissAlert(response: tempResponse)
        
        let exp = expectation(description: "Await hide alert")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            exp.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        
        // then
        
        XCTAssertTrue(viewControllerSpy.wasHideAlertCalled, "hideAlert() called correctly")
        XCTAssertTrue(viewControllerSpy.immediately, "immediately passed correctly")
    }
    
    func testDismissAlert_UpdateStatusBar() {
        
        // given
        
        setupViewController()
        
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
        
        let alertToPop: AnyAlertViewController = (AnyAlertManager.shared.alerts[vcName]?.last)!
        let alertToPopId: String = (alertToPop.dataStore?.id)!
        
        let exp1 = expectation(description: "Await show alert")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            exp1.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        
        // when
        
        let tempResponse: AnyAlertAction.Dismiss.Response = AnyAlertAction.Dismiss.Response(
            delegate: AnyAlertManager.shared,
            id: alertToPopId,
            closeSpeed: 0.5,
            hasNavBar: false,
            parentVcName: vcName,
            initialStatusBarStyle: .default,
            startPositionY: -26.0,
            immediately: false
        )
        sut.dismissAlert(response: tempResponse)
        
        let exp2 = expectation(description: "Await hide alert")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            exp2.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        
        // then
        
        XCTAssertTrue(viewControllerSpy.wasSetStatusBarStyleCalled, "setStatusBarStyle() called correctly")
    }
    
    func testDismissAlert_UpdateStatusBar_NavBar() {
        
        // given
        
        setupNavController()
        
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
        
        let alertToPop: AnyAlertViewController = (AnyAlertManager.shared.alerts[vcName]?.last)!
        let alertToPopId: String = (alertToPop.dataStore?.id)!
        
        let exp1 = expectation(description: "Await show alert")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            exp1.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        
        // when
        
        let tempResponse: AnyAlertAction.Dismiss.Response = AnyAlertAction.Dismiss.Response(
            delegate: AnyAlertManager.shared,
            id: alertToPopId,
            closeSpeed: 0.5,
            hasNavBar: true,
            parentVcName: vcName,
            initialStatusBarStyle: .default,
            startPositionY: -26.0,
            immediately: false
        )
        sut.dismissAlert(response: tempResponse)
        
        let exp2 = expectation(description: "Await hide alert")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            exp2.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        
        // then
        
        XCTAssertFalse(viewControllerSpy.wasSetStatusBarStyleCalled, "setStatusBarStyle() not called correctly")
    }
    
    func testDismissAlert_UpdateStatusBar_Immediately() {
        
        // given
        
        setupViewController()
        
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
        
        let alertToPop: AnyAlertViewController = (AnyAlertManager.shared.alerts[vcName]?.last)!
        let alertToPopId: String = (alertToPop.dataStore?.id)!
        
        
        // when
        
        let exp1 = expectation(description: "Await show alert")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            exp1.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        let tempResponse: AnyAlertAction.Dismiss.Response = AnyAlertAction.Dismiss.Response(
            delegate: AnyAlertManager.shared,
            id: alertToPopId,
            closeSpeed: 0.5,
            hasNavBar: true,
            parentVcName: vcName,
            initialStatusBarStyle: .default,
            startPositionY: -26.0,
            immediately: true
        )
        sut.dismissAlert(response: tempResponse)
        
        let exp2 = expectation(description: "Await hide alert")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            exp2.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        
        // then
        
        XCTAssertFalse(viewControllerSpy.wasSetStatusBarStyleCalled, "setStatusBarStyle() not called correctly")
    }
    
    func testDismissAlert_UpdateStatusBar_Pop() {
        
        // given
        
        setupViewController()
        
        let tempAlert1: AnyAlert = AnyAlert(
            message: "Test Message",
            backgroundColor: UIColor.white,
            statusBarStyle: .lightContent,
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
        AnyAlertManager.show(tempAlert1, from: vc)
        
        let tempAlert2: AnyAlert = AnyAlert(
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
        AnyAlertManager.show(tempAlert2, from: vc)
        
        let alertToPop: AnyAlertViewController = (AnyAlertManager.shared.alerts[vcName]?.last)!
        let alertToPopId: String = (alertToPop.dataStore?.id)!
        
        
        // when
        
        let exp1 = expectation(description: "Await show alert")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            exp1.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        let tempResponse: AnyAlertAction.Dismiss.Response = AnyAlertAction.Dismiss.Response(
            delegate: AnyAlertManager.shared,
            id: alertToPopId,
            closeSpeed: 0.5,
            hasNavBar: false,
            parentVcName: vcName,
            initialStatusBarStyle: .default,
            startPositionY: -26.0,
            immediately: false
        )
        sut.dismissAlert(response: tempResponse)
        
        let exp2 = expectation(description: "Await hide alert")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            exp2.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        
        // then
        
        XCTAssertTrue(viewControllerSpy.statusBarStyle == .lightContent, "Status bar style set correctly")
    }
    
    func testDismissAlert_UpdateStatusBar_MultiplePop() {
        
        // given
        
        setupViewController()
        
        let tempAlert1: AnyAlert = AnyAlert(
            message: "Test Message",
            backgroundColor: UIColor.white,
            statusBarStyle: .lightContent,
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
        AnyAlertManager.show(tempAlert1, from: vc)
        
        let tempAlert2: AnyAlert = AnyAlert(
            message: "Test Message",
            backgroundColor: UIColor.white,
            statusBarStyle: .lightContent,
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
        AnyAlertManager.show(tempAlert2, from: vc)
        
        let alertToPop: AnyAlertViewController = (AnyAlertManager.shared.alerts[vcName]?.last)!
        let alertToPopId: String = (alertToPop.dataStore?.id)!
        
        
        // when
        
        let exp1 = expectation(description: "Await show alert")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            exp1.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        let tempResponse: AnyAlertAction.Dismiss.Response = AnyAlertAction.Dismiss.Response(
            delegate: AnyAlertManager.shared,
            id: alertToPopId,
            closeSpeed: 0.5,
            hasNavBar: false,
            parentVcName: vcName,
            initialStatusBarStyle: .default,
            startPositionY: -26.0,
            immediately: false
        )
        sut.dismissAlert(response: tempResponse)
        
        let exp2 = expectation(description: "Await hide alert")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            exp2.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        let alertToPop2: AnyAlertViewController = (AnyAlertManager.shared.alerts[vcName]?.last)!
        let alertToPopId2: String = (alertToPop2.dataStore?.id)!
        
        let tempResponse2: AnyAlertAction.Dismiss.Response = AnyAlertAction.Dismiss.Response(
            delegate: AnyAlertManager.shared,
            id: alertToPopId2,
            closeSpeed: 0.5,
            hasNavBar: false,
            parentVcName: vcName,
            initialStatusBarStyle: .default,
            startPositionY: -26.0,
            immediately: false
        )
        sut.dismissAlert(response: tempResponse2)
        
        let exp3 = expectation(description: "Await hide alert")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            exp3.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        
        // then
        
        XCTAssertTrue(viewControllerSpy.wasSetStatusBarStyleCalled, "setStatusBarStyle() called correctly")
        XCTAssertTrue(viewControllerSpy.statusBarStyle == .default, "statusBarStyle passed correctly")
    }
}
