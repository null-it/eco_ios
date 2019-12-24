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
    
    init(view: MapViewController?) {
        self.view = view
    }
    
    
}

// MARK: - MapRouterProtocol

extension MapRouter: MapRouterProtocol {
    
    func presentCityView() {
        guard let view = view else { return }
        
        let configurator = CitiesConfigurator()
        let vc = configurator.viewController
        
        view.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func presentSaleInfoView() {
        guard let view = view else { return }
        
        let configurator = SaleInfoConfigurator()
        let vc = configurator.viewController
        
        view.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func popView() {
        view?.navigationController?.popViewController(animated: true)
    }
    
}
