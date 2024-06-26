//
//  AnyAlertViewController.swift
//  AnyAlert
//
//  Created by Chris Allinson on 2018-01-20.
//  Copyright (c) 2018 Chris Allinson. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol AnyAlertDisplayLogic: AnyObject {
    func setStyle(viewModel: AnyAlertAction.Display.ViewModel)
    func setMessage(viewModel: AnyAlertAction.Display.ViewModel)
    func setCloseButtonVisibility(viewModel: AnyAlertAction.Display.ViewModel)
    func setStatusBarStyle(viewModel: AnyAlertAction.Display.ViewModel)
    func showAlert(viewModel: AnyAlertAction.Display.ViewModel)
    func hideAlert(viewModel: AnyAlertAction.Dismiss.ViewModel)
}

protocol AnyAlertDelegate {
    func popAlert(id: String, parentVcName: String)
}

class AnyAlertViewController: UIViewController {
    
    // MARK: instance properties
    
    @IBOutlet var alertContainer: UIView?
    @IBOutlet var topConstraint: NSLayoutConstraint?
    @IBOutlet var labelTopConstraint: NSLayoutConstraint?
    @IBOutlet var heightConstraint: NSLayoutConstraint?
    @IBOutlet var messageLabel: UILabel?
    @IBOutlet var closeButton: UIButton?
    
    private var statusBarStyle: UIStatusBarStyle = .default
    private var safeAreaHeight: Double = 0.0
    
    private var tapGestureRecognizer: UITapGestureRecognizer?
    
    var interactor: AnyAlertBusinessLogic?
    var dataStore: AnyAlertDataStore?
    
    
    
    // MARK: lifecycle methods
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    class func initialize(delegate: AnyAlertDelegate, alert: AnyAlert, parentVcName: String, initialStatusBarStyle: UIStatusBarStyle, statusBarStyler: ((UIStatusBarStyle) -> Void)?, hasNavBar: Bool, tapHandler: (() -> Void)? = nil) -> AnyAlertViewController {
        let storyboard = UIStoryboard(name: "AnyAlert", bundle: Bundle(for: self.classForCoder()))
        let vc = storyboard.instantiateViewController(withIdentifier: "AnyAlertViewController") as! AnyAlertViewController
        vc.view.frame = CGRect(x: 0.0, y: 0.0, width: vc.view.frame.size.width, height: 0.0)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        
        // determine height
        let fontBeingUsed = vc.messageLabel?.font ?? alert.messageFont
        let widthOfLabel = vc.view.frame.size.width - 32 - 32
        let heightOfLabel = alert.message.heightWithConstrainedWidth(width: widthOfLabel, font: fontBeingUsed)
        let alertHeight = heightOfLabel + 5 + 5 + alert.padding + alert.padding
        
        vc.dataStore?.delegate = delegate
        vc.dataStore?.id = UUID().uuidString
        vc.dataStore?.message = alert.message
        vc.dataStore?.backgroundColor = alert.backgroundColor
        vc.dataStore?.messageFont = alert.messageFont
        vc.dataStore?.messageColor = alert.messageColor
        vc.dataStore?.closeButtonFont = alert.closeButtonFont
        vc.dataStore?.closeButtonColor = alert.closeButtonColor
        vc.dataStore?.parentVcName = parentVcName
        vc.dataStore?.initialStatusBarStyle = initialStatusBarStyle
        vc.dataStore?.statusBarStyler = statusBarStyler
        vc.dataStore?.doesSelfDismiss = alert.doesSelfDismiss
        vc.dataStore?.safeAreaInsetsHeight = UIApplication.shared.safeAreaTopInsetsHeight
        if hasNavBar {
            vc.dataStore?.height = alertHeight
        } else {
            vc.dataStore?.height = alertHeight + UIApplication.shared.safeAreaTopInsetsHeight
        }
        vc.dataStore?.statusBarStyle = alert.statusBarStyle
        vc.dataStore?.hasNavBar = hasNavBar
        if hasNavBar {
            vc.dataStore?.startPositionY = -1.0 * alertHeight
        } else {
            vc.dataStore?.startPositionY = -1.0 * (alertHeight + UIApplication.shared.safeAreaTopInsetsHeight)
        }
        vc.dataStore?.endPositionY = 0.0
        vc.dataStore?.openSpeed = alert.openSpeed
        vc.dataStore?.closeSpeed = alert.closeSpeed
        vc.dataStore?.showFor = alert.showFor
        vc.dataStore?.tapHandler = tapHandler
        
        return vc
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setHeightConstraint()
        setTopConstraint()
        setLabelConstraint()
        setTapGestureRecognizer()
        setAccessibilityLabels()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        displayAlert()
        UIAccessibility.setFocusTo(messageLabel)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        dismissAlert(immediately: true)
    }
    
    deinit {
        removeTapGestureRecognizer()
    }
    
    
    
    // MARK: UI Events
    
    @IBAction func closePressed() {
        dismissAlert()
    }
    
    
    
    // MARK: gesture handlers
    
    @objc func alertTapped() {
        guard let tapHandler = dataStore?.tapHandler else {
            return
        }
        
        tapHandler()
    }
    
    
    
    // MARK: private methods
    
    private func setup() {
        let viewController: AnyAlertViewController = self
        let interactor: AnyAlertInteractor = AnyAlertInteractor()
        let presenter: AnyAlertPresenter = AnyAlertPresenter()
        viewController.interactor = interactor
        viewController.dataStore = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
    private func setHeightConstraint() {
        guard let height = dataStore?.height else {
            return
        }
        
        heightConstraint?.constant = CGFloat(height)
        view.layoutIfNeeded()
    }
    
    private func setTopConstraint() {
        guard let tempStartY = dataStore?.startPositionY else {
            return
        }
        
        topConstraint?.constant = CGFloat(tempStartY)
        view.layoutIfNeeded()
    }
    
    private func setLabelConstraint() {
        guard let hasNavBar = dataStore?.hasNavBar else {
            return
        }
        guard !hasNavBar else {
            return
        }
        guard let safeAreaInsetsHeight = dataStore?.safeAreaInsetsHeight else {
            return
        }
        
        labelTopConstraint?.constant = CGFloat(safeAreaInsetsHeight)
        view.layoutIfNeeded()
    }
    
    private func setTapGestureRecognizer() {
        guard dataStore?.tapHandler != nil else {
            return
        }
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(alertTapped))
        if let gesture = tapGestureRecognizer {
            messageLabel?.addGestureRecognizer(gesture)
            messageLabel?.isUserInteractionEnabled = true
        }
    }
    
    private func removeTapGestureRecognizer() {
        if let gesture = tapGestureRecognizer {
            messageLabel?.removeGestureRecognizer(gesture)
        }
    }
    
    private func setAccessibilityLabels() {
        guard let tempDataStore = dataStore else {
            return
        }
        
        messageLabel?.accessibilityLabel = "\(tempDataStore.message)"
        if let _ = tapGestureRecognizer, let labelAccessibilityHint = tempDataStore.labelAccessibilityHint {
            messageLabel?.accessibilityHint = labelAccessibilityHint
            messageLabel?.accessibilityTraits = [ .button ]
        }
        
        if let closeButtonAccessibilityLabel = tempDataStore.closeButtonAccessibilityLabel {
            closeButton?.accessibilityLabel = closeButtonAccessibilityLabel
        }
        if let closeButtonAccessibilityHint = tempDataStore.closeButtonAccessibilityHint {
            closeButton?.accessibilityHint = closeButtonAccessibilityHint
        }
    }
    
    private func displayAlert() {
        guard let tempDataStore = dataStore else {
            return
        }
        
        let request: AnyAlertAction.Display.Request = AnyAlertAction.Display.Request(
            delegate: tempDataStore.delegate,
            id: tempDataStore.id,
            message: tempDataStore.message,
            backgroundColor: tempDataStore.backgroundColor,
            statusBarStyle: tempDataStore.statusBarStyle,
            messageFont: tempDataStore.messageFont,
            messageColor: tempDataStore.messageColor,
            closeButtonFont: tempDataStore.closeButtonFont,
            closeButtonColor: tempDataStore.closeButtonColor,
            openSpeed: tempDataStore.openSpeed,
            closeSpeed: tempDataStore.closeSpeed,
            doesSelfDismiss: tempDataStore.doesSelfDismiss,
            showFor: tempDataStore.showFor,
            hasNavBar: tempDataStore.hasNavBar,
            parentVcName: tempDataStore.parentVcName,
            initialStatusBarStyle: tempDataStore.initialStatusBarStyle,
            statusBarStyler: tempDataStore.statusBarStyler,
            startPositionY: tempDataStore.startPositionY,
            endPositionY: tempDataStore.endPositionY
        )
        interactor?.displayAlert(request: request)
    }
    
    private func dismissAlert(immediately: Bool? = false) {
        guard let tempDataStore = dataStore else {
            return
        }
        
        let tempRequest: AnyAlertAction.Dismiss.Request = AnyAlertAction.Dismiss.Request(
            delegate: tempDataStore.delegate,
            id: tempDataStore.id,
            closeSpeed: tempDataStore.closeSpeed,
            hasNavBar: tempDataStore.hasNavBar,
            parentVcName: tempDataStore.parentVcName,
            initialStatusBarStyle: tempDataStore.initialStatusBarStyle,
            startPositionY: tempDataStore.startPositionY,
            immediately: immediately!
        )
        interactor?.dismissAlert(request: tempRequest)
    }
}


// MARK: - AnyAlertDisplayLogic
extension AnyAlertViewController: AnyAlertDisplayLogic {
    
    func setStyle(viewModel: AnyAlertAction.Display.ViewModel) {
        alertContainer?.backgroundColor = viewModel.backgroundColor
        
        messageLabel?.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: viewModel.messageFont)
        messageLabel?.adjustsFontForContentSizeCategory = true
        messageLabel?.textColor = viewModel.messageColor
        
        closeButton?.titleLabel?.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: viewModel.closeButtonFont)
        closeButton?.titleLabel?.adjustsFontForContentSizeCategory = true
        closeButton?.setTitleColor(viewModel.closeButtonColor, for: .normal)
    }
    
    func setMessage(viewModel: AnyAlertAction.Display.ViewModel) {
        messageLabel?.text = viewModel.message
    }
    
    func setCloseButtonVisibility(viewModel: AnyAlertAction.Display.ViewModel) {
        closeButton?.isHidden = viewModel.shouldHideCloseButton
    }
    
    func setStatusBarStyle(viewModel: AnyAlertAction.Display.ViewModel) {
        dataStore?.statusBarStyler(viewModel.statusBarStyle)
    }
    
    func showAlert(viewModel: AnyAlertAction.Display.ViewModel) {
        topConstraint?.constant = CGFloat(viewModel.endPositionY)
        UIView.animate(withDuration: viewModel.openSpeed) {
            self.view.layoutIfNeeded()
        }
    }
    
    func hideAlert(viewModel: AnyAlertAction.Dismiss.ViewModel) {
        view.isUserInteractionEnabled = false
        topConstraint?.constant = CGFloat(viewModel.startPositionY)
        if let immediately = viewModel.immediately, immediately {
            self.view.layoutIfNeeded()
        } else {
            UIView.animate(withDuration: viewModel.closeSpeed) {
                self.view.layoutIfNeeded()
            }
        }
    }
}
