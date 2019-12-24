//
//  MapProtocols.swift
//  carWash
//
//  Created by Juliett Kuroyan on 19.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//


// MARK: - View
protocol MapViewProtocol: class {
    func showInfo(address: String, cashback: String, sales: [StockResponse]) 
    func set(latitude: Double, longitude: Double, action: (()->())?)
}

// MARK: - Presenter
protocol MapPresenterProtocol: class {
    func presentSaleInfoView()
    func popView()
    func viewDidLoad()
    func selectCity()
}

// MARK: - Router
protocol MapRouterProtocol {
    func presentSaleInfoView()
    func popView()
    func presentCityView()
}

// MARK: - Interactor
protocol MapInteractorProtocol: class {
    func getCities(onSuccess: @escaping () -> (),
                   onFailure: @escaping () -> ()?)
    func getWashes(city: String?,
                   onSuccess: @escaping (WashesResponse) -> (),
                   onFailure: @escaping () -> ()?)
    func getWash(id: Int,
                 onSuccess: @escaping (WashResponse) -> (),
                 onFailure: @escaping () -> ()?)
}

// MARK: - Configurator
protocol MapConfiguratorProtocol {
    
}
