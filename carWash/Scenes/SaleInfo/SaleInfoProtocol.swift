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
    func requestDidSend()
    func updateInfo(sale: SaleResponse)
}


// MARK: - Presenter
protocol SaleInfoPresenterProtocol: class {
    func popView()
    func addressButtonPressed(row: Int)

}


// MARK: - Router
protocol SaleInfoRouterProtocol {
    func popView()
    func presentMapView(washId: Int)
}


// MARK: - Interactor
protocol SaleInfoInteractorProtocol: class {
    func getSale(id: Int,
                 onSuccess: @escaping (SaleResponse) -> (),
                 onFailure: @escaping () -> ()?) 
}


// MARK: - Configurator
protocol SaleInfoConfiguratorProtocol {
    
}
