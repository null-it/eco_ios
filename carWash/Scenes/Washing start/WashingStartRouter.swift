//
//  WashingStartRouter.swift
//  carWash
//
//  Created by Juliett Kuroyan on 06.02.2020.
//  Copyright © 2020 VooDooLab. All rights reserved.
//

import UIKit

class WashingStartRouter {
    
    weak var view: WashingStartViewController?

    init(view: WashingStartViewController?) {
        self.view = view
    }
    
    
}

// MARK: - WashingStartRouterProtocol

extension WashingStartRouter: WashingStartRouterProtocol {
    
    func presentQRView() {
        guard let view = view else { return }
        let configurator = QRConfigurator()
        let vc = configurator.viewController
        view.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentMapView() {
        guard let view = view else { return }
        let configurator = MapConfigurator(isAuthorized: true, washId: nil, tabBarController: nil, isWashingStart: true)
        let vc = configurator.viewController
        view.navigationController?.pushViewController(vc, animated: true)
    }
    
}
