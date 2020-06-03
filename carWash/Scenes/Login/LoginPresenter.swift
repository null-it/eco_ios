//
//  LogimPresenter.swift
//  carWash
//
//  Created by Juliett Kuroyan on 26.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper


class LoginPresenter {
    
    // MARK: - Properties
    
    var phoneNumberText = ""
    var passwordText = ""

    let phoneNumberTextPattern = "+# (###) ### ## ##"
    var isPasswordSended: Bool! {
        didSet {
            if isPasswordSended {
                view.configurePasswordInput()
            } 
        }
    }
    let passwordMinLength = 3
    var lastPhoneNumber: String?
    var timer: Timer?

    unowned let view: LoginViewProtocol
    var interactor: LoginInteractorProtocol!
    let router: LoginRouterProtocol
    
    var alreadyHasPassword = false
    
    init(view: LoginViewProtocol,
         router: LoginRouterProtocol) {
        self.view = view
        self.router = router
    }
    
    
    // MARK: - Private
    
    private func setTimeout(seconds: Int) {
        guard seconds != 0 else {
            view.setTimeout(text: "")
            return
        }
        
        var seconds = seconds
        Timer.scheduledTimer(withTimeInterval: 1,
                             repeats: true) { [weak self] (timer) in
                                guard let self = self else { return }
                                self.timer = timer
                                let timeoutText = self.toString(seconds: seconds)
                                self.view.setTimeout(text: timeoutText)
                                seconds -= 1
                                
                                if seconds < 0 {
                                    timer.invalidate()
                                    self.view.setTimeout(text: "")
                                    self.view.setSendPasswordAgainButton(enabled: true)
                                    return
                                }
        }
    }
    
    
    private func toString(seconds: Int) -> String {
        let min = seconds / 60
        let sec = seconds % 60
        var text = "\(min):"
        text += String(sec).leftPadding(toLength: 2, withPad: "0")
        return text
    }
    
    
    private func obtainPassword(isFirstTime: Bool) {
        if let ints = getAllIntFrom(string: phoneNumberText) {
            let str = String(ints)
            interactor.sendPassword(phoneNumber: str, onSuccess: { [weak self] response in
                guard let self = self else { return }
                switch response.type {
                case .ok:
                    self.didReceiveResponse(seconds: response.secondsToSend,
                                            isFirstTime: isFirstTime)
                case .timeout:
                    self.didReceiveResponse(seconds: response.secondsToSend,
                                            isFirstTime: isFirstTime)
                case .error:
                    if let message = response.msg {
                        self.view.showAlert(message: message, title: "Ошибка")
                    }
                }
            }) { [weak self] in
                self?.view.showAlert(message: "Возникли проблемы соединения с сервером. Пожалуйста, попробуйте позже.", title: "Ошибка")
            }
        }
    
    }
    
    
    private func didReceiveResponse(seconds: Int?, isFirstTime: Bool) {
        self.view.setAlreadyHasPasswordButton(title: nil, hidden: true)
        alreadyHasPassword = false
        self.isPasswordSended = true
        self.view.setPasswordField(hidden: false, text: nil)
        if let seconds = seconds {
            self.setTimeout(seconds: seconds)
        }
        if isFirstTime {
            self.view.setLoginButton(title: "Войти", enabled: false)
        }
        self.obtainPasswordRequestDidSend()
    }
    
    
    private func obtainPasswordRequestDidSend() {
        self.view.setSendPasswordAgainButton(title: nil, hidden: false)
        self.view.setSendPasswordAgainButton(enabled: false)
        passwordText = ""
        self.view.setPasswordField(hidden: false, text: passwordText)
        self.view.passwordDidEnter(false)
    }
    
    
    private func login() {
        // validation (password & phone)
        if let ints = getAllIntFrom(string: phoneNumberText) {
            view.loginRequestDidSend()
            let str = String(ints)
            let dto = CheckPasswordDTO(phone: str, code: passwordText)
            interactor.checkPassword(dto: dto, onSuccess: { [weak self] (response) in
                switch response.type {
                case .ok:
                    let userToken = "\(response.data!.token_type) \(response.data!.token)"
                    KeychainWrapper.standard.set(userToken, forKey: "userToken")
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.configureFirebase()
                    
                    self?.view.loginResponseDidRecieve()
                    self?.router.presentProfileView()
                    self?.viewDidLoad()
                    self?.view.refreshView()
                case .error:
                    self?.view.loginResponseDidRecieve()
                    if let message = response.msg {
                        self?.view.showAlert(message: message, title: "Ошибка")
                    }
                }
            }) { [weak self] in
                self?.view.loginResponseDidRecieve()
                return self?.view.showAlert(message: "Возникли проблемы соединения с сервером. Пожалуйста, попробуйте позже.", title: "Ошибка") // !
            }
        }
    }
    
}


// MARK: - LoginPresenterProtocol

extension LoginPresenter: LoginPresenterProtocol {
    
    func viewDidLoad() {
        phoneNumberText = ""
        passwordText = ""
        isPasswordSended = false
        view.setPasswordField(hidden: true, text: nil)
        view.setLoginButton(title: "Получить пароль", enabled: false)
        view.clearAllFields()
        view.setSendPasswordAgainButton(title: nil, hidden: true)
        view.setAlreadyHasPasswordButton(title: nil, hidden: true) 
        alreadyHasPassword = false
        
        view.setSendPasswordAgainButton(enabled: false)
    }
    
    
    func alreadyHasPasswordButtonPressed() {
        if alreadyHasPassword {
            self.isPasswordSended = false
            self.view.setPasswordField(hidden: true, text: nil)
            self.view.setLoginButton(title: "Получить пароль", enabled: true)
            
            alreadyHasPassword = false
            view.setAlreadyHasPasswordButton(title: "Уже есть пароль", hidden: false)
            return
        }
        
        alreadyHasPassword = true
        view.setLoginButton(title: "Войти", enabled: false)
        passwordText = ""
        self.view.setPasswordField(hidden: false, text: passwordText)
        self.view.passwordDidEnter(false)
        
        isPasswordSended = true
        view.setAlreadyHasPasswordButton(title: "Получить новый пароль", hidden: false)
        
    }
    
    
    func loginButtonPressed() {
        
        if isPasswordSended {
            login()
            return
        }
        
        //        guard !phoneNumberText.isEmpty else { // validation
        //            view.showAlert(message: "Введите номер", title: "Ошибка")
        //            return
        //        }
        
        if let lastPhoneNumber = lastPhoneNumber,
            lastPhoneNumber == phoneNumberText,
            let timer = timer,
            timer.isValid {
            self.view.setAlreadyHasPasswordButton(title: nil, hidden: true)
            alreadyHasPassword = false
            self.isPasswordSended = true
            self.view.setLoginButton(title: "Войти", enabled: false)
            obtainPasswordRequestDidSend()
            return
        }
        timer?.invalidate()
        self.view.setTimeout(text: "")

        obtainPassword(isFirstTime: true)
    }
    
    
    func sendPasswordAgain() {
        obtainPassword(isFirstTime: false)
    }
    
    
    
    func getAllIntFrom(string: String)-> Int? {
        let number = Int(string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
        return number
    }
    
    func shouldChangePasswordCharacters(in range: NSRange, replacementString string: String, isFirstChange: Bool) -> Bool {
        guard !isFirstChange else {
            passwordText = string
            return true
        }
        
        guard let textRange = Range(range, in: passwordText),
            string.matches(for: "[0-9]").count ==  string.count else {
                return false
        }
        
        passwordText = passwordText.replacingCharacters(in: textRange, with: string)
        
        let entered = passwordText.count >= passwordMinLength
        view.setLoginButton(title: nil, enabled: entered)
        view.passwordDidEnter(entered)
        return true
    }
    
    
    func shouldChangePhoneNumberCharacters(in range: NSRange, replacementString string: String) -> String? {
        
        guard let textRange = Range(range, in: phoneNumberText) else {
                return nil
        }
        var newText = phoneNumberText.replacingCharacters(in: textRange, with: string)
        
        newText = newText.applyPatternOnNumbers(pattern: phoneNumberTextPattern, replacmentCharacter: "#")
        if newText.count > phoneNumberTextPattern.count {
            return nil
        }
         
        phoneNumberText = newText
        
        let entered = newText.count == phoneNumberTextPattern.count
        view.setAlreadyHasPasswordButton(title: "Уже есть пароль", hidden: !entered)
        view.setLoginButton(title: nil, enabled: entered)
        view.phoneNumberDidEnter(entered)
        
        if isPasswordSended {
            backButtonPressed()
            view.setLoginButton(title: nil, enabled: false)
        }
        
        return newText
    }
    
    
    func presentMapView() {
        router.presentMapView()
    }
    
    
    func popView() {
        router.popView()
    }
    
    func backButtonPressed() {
        guard isPasswordSended else { return }
        self.isPasswordSended = false
        self.view.setPasswordField(hidden: true, text: nil)
        setTimeout(seconds: 0) // !!!!
        self.view.setLoginButton(title: "Получить пароль", enabled: true)
        self.view.setSendPasswordAgainButton(title: nil, hidden: true)
        lastPhoneNumber = phoneNumberText
    }
    
}
