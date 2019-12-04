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
    func setPasswordField(hidden: Bool)
    func clearAllFields()
}

// MARK: - Presenter
protocol LoginPresenterProtocol: class {
    func popView()
    func loginButtonPressed() 
    func presentMapView()
    func shouldChangePhoneNumberCharacters(in range: NSRange,
                                            replacementString string: String) -> String?
    func shouldChangePasswordCharacters(in range: NSRange,
                                        replacementString string: String) -> Bool
    func viewWillAppear()
}

// MARK: - Router
protocol LoginRouterProtocol {
    func popView()
    func presentProfileView()
    func presentMapView()
}

// MARK: - Interactor
protocol LoginInteractorProtocol: class {
    
}

// MARK: - Configurator
protocol LoginConfiguratorProtocol {
    
}
