//
//  LogimPresenter.swift
//  carWash
//
//  Created by Juliett Kuroyan on 26.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import Foundation

class LoginPresenter {
    
    var phoneNumberText = ""
    var passwordText = ""
    
    let phoneNumberTextPattern = "+# (###) ### ## ##"
    var isPasswordSended = false
    let passwordLength = 6
    
    unowned let view: LoginViewProtocol
    var interactor: LoginInteractorProtocol!
    let router: LoginRouterProtocol
    
    init(view: LoginViewProtocol,
         router: LoginRouterProtocol) {
        self.view = view
        self.router = router
        
    }
    
}


extension LoginPresenter: LoginPresenterProtocol {
    
    func viewWillAppear() {
        phoneNumberText = ""
        passwordText = ""
        isPasswordSended = false
        view.setPasswordField(hidden: true)
        view.setLoginButton(title: "Получить пароль", enabled: false)
        view.clearAllFields()
        view.setSendPasswordAgainButton(title: nil, hidden: true)
    }

    
    func loginButtonPressed() {
        if isPasswordSended {
            // check password
            router.presentProfileView()
            return
        }
        
        // send password
        isPasswordSended = true
        view.setPasswordField(hidden: false)
        view.setLoginButton(title: "Войти", enabled: false)
        view.setSendPasswordAgainButton(title: nil, hidden: false)
    }
    
    
    func shouldChangePasswordCharacters(in range: NSRange, replacementString string: String) -> Bool {
        guard let textRange = Range(range, in: passwordText),
            string.matches(for: "[0-9]").count ==  string.count else {
                return false
        }
        
        let newText = passwordText.replacingCharacters(in: textRange, with: string)
        if newText.count > passwordLength {
            return false
        }
        
        passwordText = newText
        view.setLoginButton(title: nil, enabled: passwordText.count == passwordLength)
        return true
    }
    
    
    func shouldChangePhoneNumberCharacters(in range: NSRange, replacementString string: String) -> String? {
        guard !isPasswordSended,
            let textRange = Range(range, in: phoneNumberText) else {
            return nil
        }
        var newText = phoneNumberText.replacingCharacters(in: textRange, with: string)
        
        newText = newText.applyPatternOnNumbers(pattern: phoneNumberTextPattern, replacmentCharacter: "#")
        if newText.count > phoneNumberTextPattern.count {
            return nil
        }
        phoneNumberText = newText
        
        view.setLoginButton(title: nil, enabled: newText.count == phoneNumberTextPattern.count)
        
        return newText
    }
    
    
    func presentMapView() {
        router.presentMapView()
    }
    
    
    func popView() {
        router.popView()
    }
    
}
