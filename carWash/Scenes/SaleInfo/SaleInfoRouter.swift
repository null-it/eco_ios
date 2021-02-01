//
//  SaleInfoRouter.swift
//  carWash
//
//  Created by Juliett Kuroyan on 25.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit

class SaleInfoRouter {
    
    weak var view: SaleInfoViewController?
    
    init(view: SaleInfoViewController?) {
        self.view = view
    }
    
}


// MARK: - SaleInfoRouterProtocol

extension SaleInfoRouter: SaleInfoRouterProtocol {
    
    func presentMapView(washId: Int) {
        guard let view = view else { return }
        let configurator = MapConfigurator(isAuthorized: true, washId: washId, tabBarController: nil, isWashingStart: false)
        let vc = configurator.viewController
        if let navigationController = view.navigationController {
            navigationController.pushViewController(vc, animated: true)
        } else {
            view.present(vc, animated: true)
        }
    }

    
    func popView() {
        view?.navigationController?.popViewController(animated: true)
    }
    
}
