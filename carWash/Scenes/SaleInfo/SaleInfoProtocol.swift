//
//  SaleInfoProtocol.swift
//  carWash
//
//  Created by Juliett Kuroyan on 25.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import Foundation

// MARK: - View
protocol SaleInfoViewProtocol: class {
    
}

// MARK: - Presenter
protocol SaleInfoPresenterProtocol: class {
    func popView()
    func addressButtonPressed() 
}

// MARK: - Router
protocol SaleInfoRouterProtocol {
    func popView()
    func presentMapView()
}

// MARK: - Interactor
protocol SaleInfoInteractorProtocol: class {
    
}

// MARK: - Configurator
protocol SaleInfoConfiguratorProtocol {
    
}
