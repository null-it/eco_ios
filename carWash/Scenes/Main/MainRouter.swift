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
    weak var tabBarController: MainTabBarController?
    
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
        tabBarController?.navigationController?.popViewController(animated: true)
    }
    
    
    func presentCityView() {
        guard let view = view else { return }
        
        let configurator = CitiesConfigurator(cityChanged: nil)
        let vc = configurator.viewController
        
        view.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentOperationsView() {
         guard let view = view else { return }
         
         let configurator = OperationsConfigurator()
         let vc = configurator.viewController
         
         view.navigationController?.pushViewController(vc, animated: true)
     }
}
