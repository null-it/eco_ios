//
//  WashingStartProtocols.swift
//  carWash
//
//  Created by Juliett Kuroyan on 06.02.2020.
//  Copyright © 2020 VooDooLab. All rights reserved.
//

import Foundation

// MARK: - View
protocol WashingStartViewProtocol: class {
  
}

// MARK: - Presenter
protocol WashingStartPresenterProtocol: class {
    func mapViewTapped()
    func qrViewTapped()
}

// MARK: - Router
protocol WashingStartRouterProtocol {
    func presentQRView()
    func presentMapView()
}

// MARK: - Configurator
protocol WashingStartConfiguratorProtocol {
    
}
