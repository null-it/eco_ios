//
//  MainRouter.swift
//  carWash
//
//  Created by Juliett Kuroyan on 18.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit

class MainRouter {
    
    weak var view: MainViewController?
    
    init(view: MainViewController?) {
        self.view = view
    }
    
    
}

// MARK: - MainRouterProtocol

extension MainRouter: MainRouterProtocol {

    func presentPaymentView() {
        guard let view = view else { return }
        let configurator = PaymentConfigurator()
        let vc = configurator.viewController
        if let navigationController = view.navigationController {
            navigationController.pushViewController(vc, animated: true)
        } else {
            vc.modalPresentationStyle = .fullScreen
            view.present(vc, animated: true, completion: nil)
        }
    }
    
    
    func popToAuthorization() {
        view?.dismiss(animated: true, completion: nil)
    }
  
}
