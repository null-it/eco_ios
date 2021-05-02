//
//  LoginViewController.swift
//  carWash
//
//  Created by Juliett Kuroyan on 26.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit
import Foundation
import FlagPhoneNumber

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    var presenter: LoginPresenterProtocol!
    var configurator: LoginConfiguratorProtocol!
    
    var isFirstPasswordChange = true
    
    lazy var activityView: UIView = {
       configureActivityView()
    }()
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var phoneNumberTextField: FPNTextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var phoneNumberView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var sendPasswordAgainButton: UIButton!
    @IBOutlet weak var sendPasswordAgainView: UIView!
    @IBOutlet weak var timeoutLabel: UILabel!
    @IBOutlet weak var alreadyHasPasswordButton: UIButton!
    
    var listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        addObservers()
        let gesture = hideKeyboardWhenTapped()
        gesture.delegate = self
//        phoneNumberTextField.setLeftPadding(LoginViewConstants.textFieldLeftPadding)
        passwordTextField.setLeftPadding(LoginViewConstants.textFieldLeftPadding)
        passwordTextField.delegate = self
        configurePhoneNumberTextField()
        configureNavigationBar()
        presenter.viewDidLoad()
        refreshView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    deinit {
        removeObservers()
    }
    
    
    // MARK: - Actions
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        presenter.loginButtonPressed()
    }
    
    @IBAction func mapButtonPressed(_ sender: Any) {
        presenter.presentMapView()
    }
    
    @IBAction func sendPasswordAgainButtonPressed(_ sender: Any) {
        setSendPasswordAgainButton(enabled: false)
        presenter.sendPasswordAgain()
    }
    
    @IBAction func alreadyHasPasswordButtomPressed(_ sender: Any) {
        presenter.alreadyHasPasswordButtonPressed()
    }
    
    
    // MARK: - Private
    
    private func configurePhoneNumberTextField() {
        phoneNumberTextField.delegate = self
        
        
        phoneNumberTextField.flagButtonSize = CGSize(width: 35, height: 35)
        phoneNumberTextField.setFlag(countryCode: .RU)
        phoneNumberTextField.hasPhoneNumberExample = true
        
        listController.setup(repository: phoneNumberTextField.countryRepository)

        listController.didSelect = { [weak self] country in
            self?.phoneNumberTextField.setFlag(countryCode: country.code)
        }
    }
    
    private func configureActivityView() -> UIView {
        let activityView = UIView()
        let currentWindow = UIApplication.shared.keyWindow!
        activityView.frame = currentWindow.frame
//        activityView.translatesAutoresizingMaskIntoConstraints = false
//        activityView.widthAnchor.constraint(equalToConstant: currentWindow.frame.width).isActive = true
//        activityView.heightAnchor.constraint(equalToConstant: currentWindow.frame.height).isActive = true
        
        activityView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        let activityIndicator = UIActivityIndicatorView()
        
        activityView.addSubview(activityIndicator)
        activityIndicator.center = activityView.center
//        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
//        activityIndicator.centerXAnchor.constraint(equalTo: activityView.centerXAnchor).isActive = true
//        activityIndicator.centerYAnchor.constraint(equalTo: activityView.centerYAnchor).isActive = true
        
        activityIndicator.startAnimating()
        activityIndicator.color = .black
        return activityView
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    
    @objc private func keyboardWillChangeFrame(notification: NSNotification) {
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?
            .cgRectValue.height {
            let value = loginButton.frame.maxY + keyboardHeight - view.frame.height + LoginViewConstants.loginButtonMinBottomSpace
            guard value > 0 else { return }
            let constant = value > LoginViewConstants.loginButtonMinBottomSpace
            ? loginButtonBottomConstraint.constant + value
            : LoginViewConstants.loginButtonDefaultBottomConstant
            animateLoginButtonConstraint(constant: constant)
        }
    }
    
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        animateLoginButtonConstraint(constant: LoginViewConstants.loginButtonDefaultBottomConstant)
    }
    
    
    private func animateLoginButtonConstraint(constant: CGFloat) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.loginButtonBottomConstraint.constant = constant
        }
        view.layoutIfNeeded()
    }
    
    
    private func configureNavigationBar() {
        title = "Авторизация"
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .semibold)] 
        navigationItem.setHidesBackButton(true, animated:true)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
}


// MARK: - LoginViewProtocol

extension LoginViewController: LoginViewProtocol {
    
    func loginRequestDidSend() {
        dismissKeyboard()
        let currentWindow = UIApplication.shared.keyWindow!
        currentWindow.addSubview(activityView)
    }
    
    func loginResponseDidRecieve() {
        activityView.removeFromSuperview()
    }
    
    
    func configurePasswordInput() {
        passwordTextField.becomeFirstResponder()
    }
        
    func passwordDidEnter(_ value: Bool) {
        passwordTextField.borderColor = value ? Constants.green : .clear
        passwordTextField.backgroundColor = value ? .white : LoginViewConstants.grey
    }
    
    func phoneNumberDidEnter(_ value: Bool) {
        phoneNumberTextField.borderColor = value ? Constants.green : .clear
        phoneNumberTextField.backgroundColor = value ? .white : LoginViewConstants.grey
    }

    
    func setTimeout(text: String) {
        timeoutLabel.text = text
    }
    
    
    func setLoginButton(title: String?, enabled: Bool) {
        loginButton.isEnabled = enabled
        loginButton.backgroundColor = enabled
            ? Constants.green
            : Constants.grey
        guard let title = title else { return }
        loginButton.setTitle(title, for: .normal)
    }
    
    
    func setPasswordField(hidden: Bool, text: String?) {
        passwordView.isHidden = hidden
        if let text = text {
            passwordTextField.text = text
        }
    }
    
    
    func setSendPasswordAgainButton(title: String?, hidden: Bool) {
        sendPasswordAgainView.isHidden = hidden
        guard let title = title else { return }
        sendPasswordAgainButton.setTitle(title, for: .normal)
    }
    
    
    func clearAllFields() {
        phoneNumberTextField.text = ""
        passwordTextField.text = ""
    }
    

    func setSendPasswordAgainButton(enabled: Bool) {
        sendPasswordAgainButton.isEnabled = enabled
        let alpha: CGFloat = enabled ? 1 : 0.5
        let textColor = sendPasswordAgainButton.titleLabel?.textColor.withAlphaComponent(alpha)
        sendPasswordAgainButton.setTitleColor(textColor, for: .normal)
    }
    
    
    func refreshView() {
        passwordDidEnter(false)
        phoneNumberDidEnter(false)
    }
    
    
    func setAlreadyHasPasswordButton(title: String?, hidden: Bool) {
        alreadyHasPasswordButton.isHidden = hidden
        alreadyHasPasswordButton.setTitle(title, for: .normal)
    }
    
    
}


// MARK: - UIGestureRecognizerDelegate

extension LoginViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return gestureRecognizer.view == touch.view
    }
    
}


// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case phoneNumberTextField:
            return true
//            return presenter.shouldChangePhoneNumberCharacters(in: range, replacementString: string)
        case passwordTextField:
            let changeCharacter = presenter.shouldChangePasswordCharacters(in: range, replacementString: string, isFirstChange: isFirstPasswordChange)
            isFirstPasswordChange = false
            return changeCharacter
        default:
            ()
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == passwordTextField {
            isFirstPasswordChange = true
        }
    }
    
}

extension LoginViewController: FPNTextFieldDelegate {
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        print(name, dialCode, code)
    }
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        setAlreadyHasPasswordButton(title: "Уже есть пароль", hidden: !isValid)
        setLoginButton(title: nil, enabled: isValid)
        phoneNumberDidEnter(isValid)
        if presenter.isPasswordSendedForUser {
            presenter.backButtonPressed()
            setLoginButton(title: nil, enabled: false)
        }
        if isValid {
            if let number = textField.getFormattedPhoneNumber(format: .E164) {
                presenter.setNumber(number)
            }
        }
    }
    
    func fpnDisplayCountryList() {
        let navigationViewController = UINavigationController(rootViewController: listController)
        listController.title = "Страны"
        listController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissCountries))
        
        present(navigationViewController, animated: true, completion: nil)
    }
    
    @objc func dismissCountries() {
        listController.dismiss(animated: true, completion: nil)
    }
}
