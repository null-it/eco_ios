//
//  MapProtocols.swift
//  carWash
//
//  Created by Juliett Kuroyan on 19.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//


// MARK: - View
protocol MapViewProtocol: class {
    func showInfo()
}

// MARK: - Presenter
protocol MapPresenterProtocol: class {
    func didSelectPoint() // !
    func presentSaleInfoView()
    func popView()
}

// MARK: - Router
protocol MapRouterProtocol {
    func presentSaleInfoView()
    func popView()
}

// MARK: - Interactor
protocol MapInteractorProtocol: class {
    
}

// MARK: - Configurator
protocol MapConfiguratorProtocol {
    
}
