//
//  LoginProtocols.swift
//  carWash
//
//  Created by Juliett Kuroyan on 26.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import Foundation

// MARK: - View
protocol LoginViewProtocol: class {
    func setLoginButton(title: String?, enabled: Bool)
    func setSendPasswordAgainButton(title: String?, hidden: Bool)
    func setPasswordField(hidden: Bool, text: String?)
    func clearAllFields()
    func setTimeout(text: String) 
    func setSendPasswordAgainButton(enabled: Bool)
    func passwordDidEnter(_ value: Bool)
    func phoneNumberDidEnter(_ value: Bool)
    func refreshView()
    func configurePasswordInput()
    func showAlert(message: String, title: String)
    func setAlreadyHasPasswordButton(title: String?, hidden: Bool)
    func loginRequestDidSend()
    func loginResponseDidRecieve()
}

// MARK: - Presenter
protocol LoginPresenterProtocol: class {
    func popView()
    func loginButtonPressed() 
    func presentMapView()
    func shouldChangePhoneNumberCharacters(in range: NSRange,
                                            replacementString string: String) -> String?
    func shouldChangePasswordCharacters(in range: NSRange,
                                        replacementString string: String,
                                        isFirstChange: Bool) -> Bool
    func viewDidLoad()
    func sendPasswordAgain()
    func backButtonPressed()
    func alreadyHasPasswordButtonPressed()
}

// MARK: - Router
protocol LoginRouterProtocol {
    func popView()
    func presentProfileView()
    func presentMapView()
}

// MARK: - Interactor
protocol LoginInteractorProtocol: class {
    func sendPassword(phoneNumber: String,
                      onSuccess: @escaping (GetAuthCodeResponse) -> (),
                      onFailure: @escaping () -> ()?)
    func checkPassword(dto: CheckPasswordDTO,
                       onSuccess: @escaping (LoginResponse) -> (),
                       onFailure: @escaping () -> ()?)
}

// MARK: - Configurator
protocol LoginConfiguratorProtocol {
    
}
