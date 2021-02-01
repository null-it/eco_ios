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
    func showAlert(message: String,
                   title: String,
                   okButtonTitle: String,
                   cancelButtonTitle: String,
                   okAction: @escaping () -> (),
                   cancelAction: @escaping () -> ())
    func reload(rows: [Int], sales: [SaleResponse?])
    func reloadData(sales: [SaleResponse?])
    func presentSaleInfoView(id: Int)
    func refreshDidEnd()
    func requestDidSend()
    func responseDidRecieve()
    func showAlert(message: String, title: String)
    func dataRefreshingError()
    func showNetworkErrorMessage()
}

// MARK: - Presenter
protocol SalesPresenterProtocol: class {
    func presentSaleInfoView(row: Int) 
    func viewDidLoad()
    func logout()
    func selectCity()
    func loadPage(for row: Int)
    func presentSaleInfoView(id: Int)
    func refreshData() 
}

// MARK: - Router
protocol SalesRouterProtocol {
    func presentSaleInfoView(id: Int)
    func popToAuthorization()
    func presentCityView(cityChanged: (() -> ())?) 
}

// MARK: - Interactor
protocol SalesInteractorProtocol: class {
    func getSales(page: Int,
                  qty: Int?,
                  city: String?,
                  onSuccess: @escaping (SalesResponse) -> (),
                  onFailure: @escaping () -> ()?)
    func logout(onSuccess: @escaping () -> (),
                onFailure: @escaping () -> ()?)
}

// MARK: - Configurator
protocol SalesConfiguratorProtocol {
    
}
