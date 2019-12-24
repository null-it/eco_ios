//
//  SalesRouter.swift
//  carWash
//
//  Created by Juliett Kuroyan on 25.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit

class SalesRouter {
    
    weak var view: SalesViewController?
    weak var tabBarController: MainTabBarController?

    init(view: SalesViewController?) {
        self.view = view
    }
    
    
}

// MARK: - SalesRouterProtocol

extension SalesRouter: SalesRouterProtocol {

    func presentSaleInfoView() {
        guard let view = view else { return }
        
        let configurator = SaleInfoConfigurator()
        let vc = configurator.viewController
        
        view.navigationController?.pushViewController(vc, animated: true)
    }
    
    
     func popToAuthorization() {
         tabBarController?.navigationController?.popViewController(animated: true)
     }
     
     
     func presentCityView() {
         guard let view = view else { return }
         
         let configurator = CitiesConfigurator()
         let vc = configurator.viewController
         
         view.navigationController?.pushViewController(vc, animated: true)
     }
     
    
  
}
