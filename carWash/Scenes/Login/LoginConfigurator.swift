//
//  LoginConfigurator.swift
//  carWash
//
//  Created by Juliett Kuroyan on 26.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit

class LoginConfigurator: LoginConfiguratorProtocol {
    
    var viewController: UIViewController
    
    required init() {
        
        let loginView: LoginViewController? = LoginViewController(nibName: LoginViewController.nibName, bundle: nil)
        
        guard let view = loginView else {
            viewController = UIViewController()
            print("error")
            return
        }
        let router = LoginRouter(view: view)
        let presenter = LoginPresenter(view: view, router: router)
        view.presenter = presenter
        let interactor = LoginInteractor(presenter: presenter)
        presenter.interactor = interactor
        viewController = view
    }
}
