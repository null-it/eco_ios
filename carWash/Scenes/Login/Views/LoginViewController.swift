//
//  LoginViewController.swift
//  carWash
//
//  Created by Juliett Kuroyan on 26.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit
import Foundation

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    var presenter: LoginPresenterProtocol!
    var configurator: LoginConfiguratorProtocol!
   
    
    // MARK: - Outlets
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var phoneNumberView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var sendPasswordAgainButton: UIButton!
    @IBOutlet weak var sendPasswordAgainView: UIView!
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        addObservers()
        let gesture = hideKeyboardWhenTapped()
        gesture.delegate = self
        phoneNumberTextField.setLeftPadding(LoginViewConstants.textFieldLeftPadding)
        passwordTextField.setLeftPadding(LoginViewConstants.textFieldLeftPadding)
        phoneNumberTextField.delegate = self
        passwordTextField.delegate = self
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.viewWillAppear()
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
    
    // MARK: - Private
    
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
            print(keyboardHeight)
            let value = loginButton.frame.maxY + keyboardHeight - view.frame.height + LoginViewConstants.loginButtonMinBottomSpace
            let constant = loginButtonBottomConstraint.constant + value
            animateLoginButtonConstrain(constant: constant)
        }
    }
    
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        animateLoginButtonConstrain(constant: LoginViewConstants.loginButtonDefaultBottomConstant)
    }
    
    private func animateLoginButtonConstrain(constant: CGFloat) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.loginButtonBottomConstraint.constant = constant
        }
        view.layoutIfNeeded()
    }
    
    private func configureNavigationBar() {
        title = "Авторизация"
        navigationController?.navigationBar.titleTextAttributes =
            [ NSAttributedString.Key.font: UIFont(name: "Gilroy-Medium", size: 18)!]
        navigationItem.setHidesBackButton(true, animated:true);
    }
    
}


// MARK: - LoginViewProtocol

extension LoginViewController: LoginViewProtocol {
    
    func setLoginButton(title: String?, enabled: Bool) {
        loginButton.isEnabled = enabled
        loginButton.backgroundColor = enabled
            ? LoginViewConstants.green
            : LoginViewConstants.grey
        guard let title = title else { return }
        loginButton.setTitle(title, for: .normal)
    }
    
    
    func setPasswordField(hidden: Bool) {
        passwordView.isHidden = hidden
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
            let newString = presenter.shouldChangePhoneNumberCharacters(in: range, replacementString: string)
            if let newString = newString  {
                phoneNumberTextField.text = newString
            }
            return false
        case passwordTextField:
            return presenter.shouldChangePasswordCharacters(in: range, replacementString: string)
        default:
            ()
        }
        
        return true
    }
    
}
