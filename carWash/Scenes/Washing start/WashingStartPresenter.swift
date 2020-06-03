//
//  WashingStartPresenter.swift
//  carWash
//
//  Created by Juliett Kuroyan on 06.02.2020.
//  Copyright © 2020 VooDooLab. All rights reserved.
//

import Foundation

class WashingStartPresenter {
    
    // MARK: - Properties
    
    unowned let view: WashingStartViewProtocol
    let router: WashingStartRouterProtocol
    
    
    // MARK: - Lifecycle
    
    init(view: WashingStartViewProtocol,
         router: WashingStartRouterProtocol) {
        self.view = view
        self.router = router
    }
    
    
}

// MARK: - WashingStartPresenterProtocol

extension WashingStartPresenter: WashingStartPresenterProtocol {
    
    func mapViewTapped() {
        router.presentMapView()
    }
    
    func qrViewTapped() {
        router.presentQRView()
    }
    
}
