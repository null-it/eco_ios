//
//  SalesProtocol.swift
//  carWash
//
//  Created by Juliett Kuroyan on 25.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import Foundation

// MARK: - View
protocol SalesViewProtocol: class {
   
}

// MARK: - Presenter
protocol SalesPresenterProtocol: class {
   func presentSaleInfoView()
}

// MARK: - Router
protocol SalesRouterProtocol {
    func presentSaleInfoView()
}

// MARK: - Interactor
protocol SalesInteractorProtocol: class {
    
}

// MARK: - Configurator
protocol SalesConfiguratorProtocol {
    
}
