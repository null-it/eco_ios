//
//  MapProtocols.swift
//  carWash
//
//  Created by Juliett Kuroyan on 19.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//


// MARK: - View
protocol MapViewProtocol: class {
    func showInfo(address: String, cashback: String, sales: [StockResponse], happyTimesText: String?, isHappyTimesHidden: Bool) 
    func set(latitude: Double, longitude: Double, id: Int, cashbackText: String, action: (()->())?) 
    func selectWash(id: Int)
    func configureSelectedWashMode()
    func configureDefaultMode(latitude: Double, longitude: Double)
    func showAlert(message: String,
                   title: String,
                   okButtonTitle: String,
                   cancelButtonTitle: String,
                   okAction: @escaping () -> (),
                   cancelAction: @escaping () -> ())
    func requestDidSend()
    func responseDidRecieve()
}

// MARK: - Presenter
protocol MapPresenterProtocol: class {
    func presentSaleInfoView(row: Int) 
    func popView()
    func viewDidLoad()
    func selectCity(cityChanged: (() -> ())?) 
    func viewWillAppear()
    func logout()
}

// MARK: - Router
protocol MapRouterProtocol {
    func presentSaleInfoView(id: Int)
    func popView()
    func presentCityView(cityChanged: (() -> ())?)
    func popToAuthorization()
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
    func logout(onSuccess: @escaping () -> (),
                onFailure: @escaping () -> ()?)
}

// MARK: - Configurator
protocol MapConfiguratorProtocol {
    
}
