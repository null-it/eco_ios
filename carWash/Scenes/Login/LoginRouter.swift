//
//  LoginRouter.swift
//  carWash
//
//  Created by Juliett Kuroyan on 26.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit

class LoginRouter {
    
    weak var view: LoginViewController?
    
    init(view: LoginViewController?) {
        self.view = view
    }
    
}

// MARK: - LoginRouterProtocol

extension LoginRouter: LoginRouterProtocol {
    
    func presentMapView() {
        guard let view = view else { return }
        let configurator = MapConfigurator(isAuthorized: false, washId: nil, tabBarController: nil, isWashingStart: false)
        let vc = configurator.viewController
        if let navigationController = view.navigationController {
            navigationController.pushViewController(vc, animated: true)
        } else {
            let navigationController = UINavigationController(rootViewController: vc)
            navigationController.modalPresentationStyle = .formSheet
            view.present(navigationController, animated: true, completion: nil)
        }
    }
    

    func popView() {
        view?.navigationController?.popViewController(animated: true)
    }
    
    
    func presentProfileView() {
        guard let view = view else { return }
        let vc = MainTabBarController()
        view.navigationController?.pushViewController(vc, animated: true)
        view.navigationController? .navigationBar.isHidden = true
    }
  
}
