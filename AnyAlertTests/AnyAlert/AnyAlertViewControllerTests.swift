//
//  AnyAlertViewControllerTests.swift
//  AnyApp
//
//  Created by Chris Allinson on 2018-01-25.
//  Copyright © 2018 Chris Allinson. All rights reserved.
//

@testable import AnyAlert


import XCTest
import UIKit

class AnyAlertViewControllerTests: XCTestCase {
    
    // MARK: instance variables
    
    var window: UIWindow!
    var vc: UIViewController!
    var vcName: String!
    var navController: UINavigationController!
    
    var sut: AnyAlertViewController!
    var mockDelegate: MockAnyAlertDelegate!
    
    
    
    // MARK: lifecycle methods
    
    override func setUp() {
        super.setUp()
        
        setupMockDelegate()
    }
    
    override func tearDown() {
        window = nil
        vc = nil
        vcName = nil
        navController = nil
        
        sut = nil
        mockDelegate = nil
        
        UIApplication.shared.statusBarStyle = .default
        
        super.tearDown()
    }
    
    
    
    // MARK: setup
    
    func setupMockDelegate() {
        mockDelegate = MockAnyAlertDelegate()
    }
    
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
    
    func setupBasicAlert() -> AnyAlert {
        return AnyAlert(
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
    }
    
    func setupSelfDismissingAlert() -> AnyAlert {
        return AnyAlert(
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
            doesSelfDismiss: true,
            showFor: 1.0
        )
    }
    
    
    
    // MARK: Spies
    
    class AnyAlertInteractorSpy: AnyAlertDataStore, AnyAlertBusinessLogic {
        
        var wasDisplayAlertCalled: Bool = false
        var wasDismissAlertCalled: Bool = false
        
        

        // AlertDataStore
        
        var delegate: AnyAlertDelegate!
        
        var id: String = ""
        var message: String = ""
        var backgroundColor: UIColor!
        var messageFont: UIFont!
        var messageColor: UIColor!
        var closeButtonFont: UIFont!
        var closeButtonColor: UIColor!
        var parentVcName: String = ""
        var initialStatusBarStyle: UIStatusBarStyle!
        var doesSelfDismiss: Bool!
        
        var height: Double!
        
        var statusBarStyle: UIStatusBarStyle!
        
        var hasNavBar: Bool!
        var startPositionY: Double!
        var endPositionY: Double!
        
        var openSpeed: Double!
        var closeSpeed: Double!
        
        var showFor: Double!
        
        var tapHandler: (() -> Void)?
        
        
        
        // AlertBusinessLogic
        
        func displayAlert(request: AnyAlertAction.Display.Request) {
            wasDisplayAlertCalled = true
        }
        
        func dismissAlert(request: AnyAlertAction.Dismiss.Request) {
            wasDismissAlertCalled = true
        }
    }
    
    // MARK: Mocks
    
    class MockAnyAlertDelegate: AnyAlertDelegate {
        
        var wasPopAlertCalled = false
        
        func popAlert(id: String, parentVcName: String) {
            wasPopAlertCalled = true
        }
    }
    
    
    
    // MARK: Tests
    
    func testInit_DoesSelfDismiss() {
        
        // given
        
        setupViewController()
        
        let tempAlert: AnyAlert = AnyAlert(
            message: "Test Message",
            backgroundColor: UIColor.yellow,
            statusBarStyle: .lightContent,
            messageFont: UIFont.systemFont(ofSize: 12.0),
            messageColor: UIColor.orange,
            closeButtonFont: UIFont.systemFont(ofSize: 12.0),
            closeButtonColor: UIColor.red,
            height: 200.0,
            openSpeed: 1.0,
            closeSpeed: 2.0,
            doesSelfDismiss: true,
            showFor: 3.0
        )
        
        
        // when
        
        sut = AnyAlertViewController.init(
            delegate: mockDelegate,
            alert: tempAlert,
            parentVcName: vcName,
            initialStatusBarStyle: .default,
            hasNavBar: false
        )
        
        
        // then
        
        XCTAssertNotNil((sut.dataStore?.id)!, "id set correctly")
        XCTAssertTrue((sut.dataStore?.message)! == "Test Message", "message set correctly")
        XCTAssertTrue((sut.dataStore?.backgroundColor)! == UIColor.yellow, "backgroundColor set correctly")
        XCTAssertTrue((sut.dataStore?.statusBarStyle)! == .lightContent, "statusBarStyle set correctly")
        XCTAssertTrue((sut.dataStore?.messageFont)! == UIFont.systemFont(ofSize: 12.0), "messageFont set correctly")
        XCTAssertTrue((sut.dataStore?.messageColor)! == UIColor.orange, "messageColor set correctly")
        XCTAssertTrue((sut.dataStore?.closeButtonFont)! == UIFont.systemFont(ofSize: 12.0), "closeButtonFont set correctly")
        XCTAssertTrue((sut.dataStore?.closeButtonColor)! == UIColor.red, "closeButtonColor set correctly")
        XCTAssertTrue((sut.dataStore?.height)! == 200.0, "height set correctly")
        XCTAssertTrue((sut.dataStore?.openSpeed)! == 1.0, "openSpeed set correctly")
        XCTAssertTrue((sut.dataStore?.closeSpeed)! == 2.0, "closeSpeed set correctly")
        XCTAssertTrue((sut.dataStore?.doesSelfDismiss)!, "doesSelfDismiss set correctly")
        XCTAssertTrue((sut.dataStore?.showFor)! == 3.0, "showFor set correctly")
        
        XCTAssertFalse((sut.dataStore?.hasNavBar)!, "hasNavBar set correctly")
        XCTAssertTrue((sut.dataStore?.parentVcName)! == vcName, "parentVcName set correctly")
        XCTAssertTrue((sut.dataStore?.initialStatusBarStyle)! == .default, "initialStatusBarStyle set correctly")
        XCTAssertTrue((sut.dataStore?.endPositionY)! == -26.0, "endPositionY set correctly")
        
        let screenWidth: CGFloat = (UIApplication.shared.keyWindow?.rootViewController?.view.frame.size.width)!
        XCTAssertTrue(sut.view.frame == CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 200.0), "Alert frame set correctly")
    }
    
    func testInit_DoesNotSelfDismiss() {
        
        // given
        
        setupViewController()
        
        let tempAlert: AnyAlert = AnyAlert(
            message: "Test Message",
            backgroundColor: UIColor.yellow,
            statusBarStyle: .lightContent,
            messageFont: UIFont.systemFont(ofSize: 12.0),
            messageColor: UIColor.orange,
            closeButtonFont: UIFont.systemFont(ofSize: 12.0),
            closeButtonColor: UIColor.red,
            height: 200.0,
            openSpeed: 1.0,
            closeSpeed: 2.0,
            doesSelfDismiss: false,
            showFor: 3.0
        )
        
        
        // when
        
        sut = AnyAlertViewController.init(
            delegate: mockDelegate,
            alert: tempAlert,
            parentVcName: vcName,
            initialStatusBarStyle: .default,
            hasNavBar: false
        )
        
        
        // then
        
        XCTAssertFalse((sut.closeButton?.isHidden)!, "closeButton shows correctly")
        
        XCTAssertNotNil((sut.dataStore?.id)!, "id set correctly")
        XCTAssertTrue((sut.dataStore?.message)! == "Test Message", "message set correctly")
        XCTAssertTrue((sut.dataStore?.backgroundColor)! == UIColor.yellow, "backgroundColor set correctly")
        XCTAssertTrue((sut.dataStore?.statusBarStyle)! == .lightContent, "statusBarStyle set correctly")
        XCTAssertTrue((sut.dataStore?.messageFont)! == UIFont.systemFont(ofSize: 12.0), "messageFont set correctly")
        XCTAssertTrue((sut.dataStore?.messageColor)! == UIColor.orange, "messageColor set correctly")
        XCTAssertTrue((sut.dataStore?.closeButtonFont)! == UIFont.systemFont(ofSize: 12.0), "closeButtonFont set correctly")
        XCTAssertTrue((sut.dataStore?.closeButtonColor)! == UIColor.red, "closeButtonColor set correctly")
        XCTAssertTrue((sut.dataStore?.height)! == 200.0, "height set correctly")
        XCTAssertTrue((sut.dataStore?.openSpeed)! == 1.0, "openSpeed set correctly")
        XCTAssertTrue((sut.dataStore?.closeSpeed)! == 2.0, "closeSpeed set correctly")
        XCTAssertFalse((sut.dataStore?.doesSelfDismiss)!, "doesSelfDismiss set correctly")
        XCTAssertTrue((sut.dataStore?.showFor)! == 3.0, "showFor set correctly")
        
        XCTAssertFalse((sut.dataStore?.hasNavBar)!, "hasNavBar set correctly")
        XCTAssertTrue((sut.dataStore?.parentVcName)! == vcName, "parentVcName set correctly")
        XCTAssertTrue((sut.dataStore?.initialStatusBarStyle)! == .default, "initialStatusBarStyle set correctly")
        XCTAssertTrue((sut.dataStore?.endPositionY)! == -26.0, "endPositionY set correctly")
        
        let screenWidth: CGFloat = (UIApplication.shared.keyWindow?.rootViewController?.view.frame.size.width)!
        XCTAssertTrue(sut.view.frame == CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 200.0), "Alert frame set correctly")
    }
    
    func testViewDidLoad_DoesSelfDismiss() {
        
        // given
        
        setupViewController()
        
        let tempAlert: AnyAlert = setupSelfDismissingAlert()
        
        sut = AnyAlertViewController.init(
            delegate: mockDelegate,
            alert: tempAlert,
            parentVcName: vcName,
            initialStatusBarStyle: .default,
            hasNavBar: false
        )
        
        
        // when
        
        vc.view.addSubview((sut.view)!)
        sut.viewDidAppear(false)
        
        
        // then
        
        XCTAssertTrue((sut.closeButton?.isHidden)!, "closeButton hides correctly")
    }
    
    func testViewDidLoad_DoesNotSelfDismiss() {
        
        // given
        
        setupViewController()
        
        let tempAlert: AnyAlert = setupBasicAlert()
        
        sut = AnyAlertViewController.init(
            delegate: mockDelegate,
            alert: tempAlert,
            parentVcName: vcName,
            initialStatusBarStyle: .default,
            hasNavBar: false
        )
        
        
        // when
        
        vc.view.addSubview((sut.view)!)
        sut.viewDidAppear(false)
        
        
        // then
        
        XCTAssertFalse((sut.closeButton?.isHidden)!, "closeButton shows correctly")
    }
    
    func testViewWillAppear_NoNavBar() {
        
        // given
        
        setupViewController()
        
        let tempAlert: AnyAlert = setupBasicAlert()
        
        sut = AnyAlertViewController.init(
            delegate: mockDelegate,
            alert: tempAlert,
            parentVcName: vcName,
            initialStatusBarStyle: .default,
            hasNavBar: false
        )
        
        let sutHeight: CGFloat = sut.view.frame.size.height
        
        
        // when
        
        vc.view.addSubview((sut.view)!)
        sut.viewWillAppear(false)
        
        
        // then
        
        XCTAssertTrue((sut.topConstraint?.constant)! == (-1.0 * sutHeight), "topConstraint set correctly")
    }
    
    func testViewWillAppear_NavBar() {
        
        // given
        
        setupNavController()
        
        let tempAlert: AnyAlert = setupBasicAlert()
        
        sut = AnyAlertViewController.init(
            delegate: mockDelegate,
            alert: tempAlert,
            parentVcName: vcName,
            initialStatusBarStyle: .default,
            hasNavBar: true
        )
        
        let sutHeight: CGFloat = sut.view.frame.size.height
        
        
        // when
        
        vc.view.addSubview((sut.view)!)
        sut.viewWillAppear(false)
        
        
        // then
        
        XCTAssertTrue((sut.topConstraint?.constant)! == (-1.0 * sutHeight), "topConstraint set correctly")
    }
    
    func testViewDidAppear_NoNavBar() {
        
        // given
        
        setupViewController()
        
        let tempAlert: AnyAlert = setupBasicAlert()
        
        sut = AnyAlertViewController.init(
            delegate: mockDelegate,
            alert: tempAlert,
            parentVcName: vcName,
            initialStatusBarStyle: .default,
            hasNavBar: false
        )
        
        let sutHeight: CGFloat = sut.view.frame.size.height
        
        let interactorSpy: AnyAlertInteractorSpy = AnyAlertInteractorSpy()
        sut.interactor = interactorSpy
        
        
        // when
        
        vc.view.addSubview((sut.view)!)
        sut.viewDidAppear(false)
        
        
        // then
        
        XCTAssertTrue(interactorSpy.wasDisplayAlertCalled, "Interactor displayAlert() called correctly")
        XCTAssertTrue((sut.topConstraint?.constant)! == (-1.0 * sutHeight), "topConstraint set correctly")
    }
    
    func testViewDidAppear_NavBar() {
        
        // given
        
        setupNavController()
        
        let tempAlert: AnyAlert = setupBasicAlert()
        
        sut = AnyAlertViewController.init(
            delegate: mockDelegate,
            alert: tempAlert,
            parentVcName: vcName,
            initialStatusBarStyle: .default,
            hasNavBar: true
        )
        
        let sutHeight: CGFloat = sut.view.frame.size.height
        
        let interactorSpy: AnyAlertInteractorSpy = AnyAlertInteractorSpy()
        sut.interactor = interactorSpy
        
        
        // when
        
        navController.pushViewController(sut, animated: false)
        
        let exp = expectation(description: "Await present alert")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            exp.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        
        // then
        
        XCTAssertTrue(interactorSpy.wasDisplayAlertCalled, "Interactor displayAlert() called correctly")
        XCTAssertTrue((sut.topConstraint?.constant)! == (-1.0 * sutHeight), "topConstraint set correctly")
    }
    
    func testViewWillDisappear() {
        
        // given
        
        setupViewController()
        
        let tempAlert: AnyAlert = setupBasicAlert()
        
        sut = AnyAlertViewController.init(
            delegate: mockDelegate,
            alert: tempAlert,
            parentVcName: vcName,
            initialStatusBarStyle: .default,
            hasNavBar: false
        )
        
        let interactorSpy: AnyAlertInteractorSpy = AnyAlertInteractorSpy()
        sut.interactor = interactorSpy
        
        vc.view.addSubview((sut.view)!)
        sut.viewDidAppear(false)
        
        let exp = expectation(description: "Await present alert")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            exp.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        
        // when
        
        sut.viewWillDisappear(false)
        
        
        // then
        
        XCTAssertTrue(interactorSpy.wasDismissAlertCalled, "Interactor dismissAlert() called correctly")
    }
    
    func testDoesSelfDismiss() {
        
        // given
        
        setupViewController()
        
        let tempAlert: AnyAlert = setupSelfDismissingAlert()
        
        sut = AnyAlertViewController.init(
            delegate: mockDelegate,
            alert: tempAlert,
            parentVcName: vcName,
            initialStatusBarStyle: .default,
            hasNavBar: false
        )
        
        let duration = (sut.dataStore?.openSpeed)! + (sut.dataStore?.showFor)! + (sut.dataStore?.closeSpeed)! + 1.0
        
        
        // when
        
        vc.view.addSubview((sut.view)!)
        
        let exp = expectation(description: "Await present/show/dismiss alert")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            exp.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        
        // then
        
        XCTAssertTrue(mockDelegate.wasPopAlertCalled, "mockDelegate popAlert() called correctly")
    }
    
    func testDoesNotSelfDismiss() {
        
        // given
        
        setupViewController()
        
        let tempAlert: AnyAlert = setupBasicAlert()
        
        sut = AnyAlertViewController.init(
            delegate: mockDelegate,
            alert: tempAlert,
            parentVcName: vcName,
            initialStatusBarStyle: .default,
            hasNavBar: false
        )
        
        let duration = (sut.dataStore?.openSpeed)! + (sut.dataStore?.showFor)! + (sut.dataStore?.closeSpeed)! + 1.0
        
        
        // when
        
        vc.view.addSubview((sut.view)!)
        
        let exp = expectation(description: "Await present/show/dismiss alert")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            exp.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        
        // then
        
        XCTAssertFalse(mockDelegate.wasPopAlertCalled, "mockDelegate popAlert() not called correctly")
    }
    
    func testClosePressed() {
        
        // given
        
        setupViewController()
        
        let tempAlert: AnyAlert = setupBasicAlert()
        
        sut = AnyAlertViewController.init(
            delegate: mockDelegate,
            alert: tempAlert,
            parentVcName: vcName,
            initialStatusBarStyle: .default,
            hasNavBar: false
        )
        
        let interactorSpy: AnyAlertInteractorSpy = AnyAlertInteractorSpy()
        sut.interactor = interactorSpy
        
        
        // when
        
        sut.closePressed()
        
        
        // then
        
        XCTAssertTrue(interactorSpy.wasDismissAlertCalled, "Interactor dismissAlert() called correctly")
    }
    
    func testAlertTapped() {
        
        // given
        
        setupViewController()
        
        let tempAlert: AnyAlert = setupBasicAlert()
        
        var tempBool: Bool = false
        
        sut = AnyAlertViewController.init(
            delegate: mockDelegate,
            alert: tempAlert,
            parentVcName: vcName,
            initialStatusBarStyle: .default,
            hasNavBar: false,
            tapHandler: {
                tempBool = true
            }
        )
        
        
        // when
        
        sut.alertTapped()
        
        
        // then
        
        XCTAssertTrue(tempBool, "tapHandler functions correctly")
    }
    
    func testSetMessage() {
        
        // given
        
        setupViewController()
        
        let tempAlert: AnyAlert = setupBasicAlert()
        
        sut = AnyAlertViewController.init(
            delegate: mockDelegate,
            alert: tempAlert,
            parentVcName: vcName,
            initialStatusBarStyle: .default,
            hasNavBar: false
        )
        
        
        // when
        
        let tempViewModel: AnyAlertAction.Display.ViewModel = AnyAlertAction.Display.ViewModel(
            message: "new message",
            backgroundColor: UIColor.white,
            statusBarStyle: .default,
            messageFont: UIFont.systemFont(ofSize: 12.0),
            messageColor: UIColor.white,
            closeButtonFont: UIFont.systemFont(ofSize: 12.0),
            closeButtonColor: UIColor.white,
            openSpeed: -1.0,
            closeSpeed: -1.0,
            shouldHideCloseButton: false,
            endPositionY: -26.0
        )
        sut.setMessage(viewModel: tempViewModel)
        
        
        // then
        
        XCTAssertTrue((sut.messageLabel?.text)! == "new message", "messageLabel set correctly")
    }
    
    func testSetCloseButtonVisibility_Show() {
        
        // given
        
        setupViewController()
        
        let tempAlert: AnyAlert = setupSelfDismissingAlert()
        
        sut = AnyAlertViewController.init(
            delegate: mockDelegate,
            alert: tempAlert,
            parentVcName: vcName,
            initialStatusBarStyle: .default,
            hasNavBar: false
        )
        
        
        // when
        
        let tempViewModel: AnyAlertAction.Display.ViewModel = AnyAlertAction.Display.ViewModel(
            message: "",
            backgroundColor: UIColor.white,
            statusBarStyle: .default,
            messageFont: UIFont.systemFont(ofSize: 12.0),
            messageColor: UIColor.white,
            closeButtonFont: UIFont.systemFont(ofSize: 12.0),
            closeButtonColor: UIColor.white,
            openSpeed: -1.0,
            closeSpeed: -1.0,
            shouldHideCloseButton: false,
            endPositionY: -26.0
        )
        sut.setCloseButtonVisibility(viewModel: tempViewModel)
        
        
        // then
        
        XCTAssertFalse((sut.closeButton?.isHidden)!, "closeButton shows correctly")
    }
    
    func testSetCloseButtonVisibility_Hide() {
        
        // given
        
        setupViewController()
        
        let tempAlert: AnyAlert = setupBasicAlert()
        
        sut = AnyAlertViewController.init(
            delegate: mockDelegate,
            alert: tempAlert,
            parentVcName: vcName,
            initialStatusBarStyle: .default,
            hasNavBar: false
        )
        
        
        // when
        
        let tempViewModel: AnyAlertAction.Display.ViewModel = AnyAlertAction.Display.ViewModel(
            message: "",
            backgroundColor: UIColor.white,
            statusBarStyle: .default,
            messageFont: UIFont.systemFont(ofSize: 12.0),
            messageColor: UIColor.white,
            closeButtonFont: UIFont.systemFont(ofSize: 12.0),
            closeButtonColor: UIColor.white,
            openSpeed: -1.0,
            closeSpeed: -1.0,
            shouldHideCloseButton: true,
            endPositionY: -26.0
        )
        sut.setCloseButtonVisibility(viewModel: tempViewModel)
        
        
        // then
        
        XCTAssertTrue((sut.closeButton?.isHidden)!, "closeButton hides correctly")
    }
    
    func testSetStatusBarStyle() {
        
        // given
        
        setupViewController()
        
        let tempAlert: AnyAlert = setupBasicAlert()
        
        sut = AnyAlertViewController.init(
            delegate: mockDelegate,
            alert: tempAlert,
            parentVcName: vcName,
            initialStatusBarStyle: .default,
            hasNavBar: false
        )
        
        
        // when
        
        let tempViewModel: AnyAlertAction.Display.ViewModel = AnyAlertAction.Display.ViewModel(
            message: "",
            backgroundColor: UIColor.white,
            statusBarStyle: .lightContent,
            messageFont: UIFont.systemFont(ofSize: 12.0),
            messageColor: UIColor.white,
            closeButtonFont: UIFont.systemFont(ofSize: 12.0),
            closeButtonColor: UIColor.white,
            openSpeed: -1.0,
            closeSpeed: -1.0,
            shouldHideCloseButton: false,
            endPositionY: -26.0
        )
        sut.setStatusBarStyle(viewModel: tempViewModel)
        
        
        // then
        
        XCTAssertTrue(UIApplication.shared.statusBarStyle == .lightContent, "statusBarStyle set correctly")
    }
    
    func testShowAlert() {
        
        // given
        
        setupViewController()
        
        let tempAlert: AnyAlert = setupBasicAlert()
        
        sut = AnyAlertViewController.init(
            delegate: mockDelegate,
            alert: tempAlert,
            parentVcName: vcName,
            initialStatusBarStyle: .default,
            hasNavBar: false
        )
        
        
        // when
        
        let tempViewModel: AnyAlertAction.Display.ViewModel = AnyAlertAction.Display.ViewModel(
            message: "",
            backgroundColor: UIColor.white,
            statusBarStyle: .default,
            messageFont: UIFont.systemFont(ofSize: 12.0),
            messageColor: UIColor.white,
            closeButtonFont: UIFont.systemFont(ofSize: 12.0),
            closeButtonColor: UIColor.white,
            openSpeed: -1.0,
            closeSpeed: -1.0,
            shouldHideCloseButton: false,
            endPositionY: -26.0
        )
        
        sut.showAlert(viewModel: tempViewModel)
        
        
        // then
        
        XCTAssertTrue((sut.topConstraint?.constant)! == -26.0, "topConstraint set correctly")
    }
    
    func testShowAlert_NavBar() {
        
        // given
        
        setupNavController()
        
        let tempAlert: AnyAlert = setupBasicAlert()
        
        sut = AnyAlertViewController.init(
            delegate: mockDelegate,
            alert: tempAlert,
            parentVcName: vcName,
            initialStatusBarStyle: .default,
            hasNavBar: false
        )
        
        
        // when
        
        let tempViewModel: AnyAlertAction.Display.ViewModel = AnyAlertAction.Display.ViewModel(
            message: "",
            backgroundColor: UIColor.white,
            statusBarStyle: .default,
            messageFont: UIFont.systemFont(ofSize: 12.0),
            messageColor: UIColor.white,
            closeButtonFont: UIFont.systemFont(ofSize: 12.0),
            closeButtonColor: UIColor.white,
            openSpeed: -1.0,
            closeSpeed: -1.0,
            shouldHideCloseButton: false,
            endPositionY: -26.0
        )
        
        sut.showAlert(viewModel: tempViewModel)
        
        
        // then
        
        XCTAssertTrue((sut.topConstraint?.constant)! == -26.0, "topConstraint set correctly")
    }
    
    func testHideAlert() {
        
        // given
        
        setupViewController()
        
        let tempAlert: AnyAlert = setupBasicAlert()
        
        sut = AnyAlertViewController.init(
            delegate: mockDelegate,
            alert: tempAlert,
            parentVcName: vcName,
            initialStatusBarStyle: .default,
            hasNavBar: false
        )
        
        
        // when
        
        let tempViewModel: AnyAlertAction.Dismiss.ViewModel = AnyAlertAction.Dismiss.ViewModel(
            closeSpeed: 0.5,
            startPositionY: -126.0,
            immediately: false
        )
        sut.hideAlert(viewModel: tempViewModel)
        
        
        // then
        
        XCTAssertTrue((sut.topConstraint?.constant)! == -126.0, "topConstraint set correctly")
    }
    
    func testHideAlert_NavBar() {
        
        // given
        
        setupNavController()
        
        let tempAlert: AnyAlert = setupBasicAlert()
        
        sut = AnyAlertViewController.init(
            delegate: mockDelegate,
            alert: tempAlert,
            parentVcName: vcName,
            initialStatusBarStyle: .default,
            hasNavBar: false
        )
        
        
        // when
        
        let tempViewModel: AnyAlertAction.Dismiss.ViewModel = AnyAlertAction.Dismiss.ViewModel(
            closeSpeed: 0.5,
            startPositionY: -126.0,
            immediately: false
        )
        sut.hideAlert(viewModel: tempViewModel)
        
        
        // then
        
        XCTAssertTrue((sut.topConstraint?.constant)! == -126.0, "topConstraint set correctly")
    }
}
