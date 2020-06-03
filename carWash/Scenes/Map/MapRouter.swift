//
//  MapRouter.swift
//  carWash
//
//  Created by Juliett Kuroyan on 19.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit

class MapRouter {
    
    weak var view: MapViewController?
    weak var tabBarController: MainTabBarController?

    init(view: MapViewController?) {
        self.view = view
    }
    
    
}

// MARK: - MapRouterProtocol

extension MapRouter: MapRouterProtocol {
    
    func presentCityView(cityChanged: (() -> ())? = nil) {
        guard let view = view else { return }
        
        let configurator = CitiesConfigurator(cityChanged: cityChanged)
        let vc = configurator.viewController
        
        view.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func presentSaleInfoView(id: Int) {
        guard let view = view else { return }
        
        let configurator = SaleInfoConfigurator(id: id)
        let vc = configurator.viewController
        
        view.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func popView() {
        view?.navigationController?.popViewController(animated: true)
    }
    
    func popToAuthorization() {
        tabBarController?.navigationController?.popViewController(animated: true)
    }
    
}
