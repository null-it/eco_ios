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
    func updateSales(sales: [SaleResponseData])
    func showAlert(message: String,
                   title: String,
                   okButtonTitle: String,
                   cancelButtonTitle: String,
                   okAction: @escaping () -> (),
                   cancelAction: @escaping () -> ())

}

// MARK: - Presenter
protocol SalesPresenterProtocol: class {
    func presentSaleInfoView()
    func viewDidLoad()
    func logout()
    func selectCity()
}

// MARK: - Router
protocol SalesRouterProtocol {
    func presentSaleInfoView()
    func popToAuthorization()
    func presentCityView()
}

// MARK: - Interactor
protocol SalesInteractorProtocol: class {
    func getSales(city: String?,
                  onSuccess: @escaping (SalesResponse) -> (),
                  onFailure: @escaping () -> ()?)
    func logout(onSuccess: @escaping () -> (),
                onFailure: @escaping () -> ()?)
}

// MARK: - Configurator
protocol SalesConfiguratorProtocol {
    
}
