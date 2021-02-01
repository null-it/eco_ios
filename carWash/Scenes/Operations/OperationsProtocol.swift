//
//  OperationsFilterProtocol.swift
//  carWash
//
//  Created by Juliett Kuroyan on 15.01.2020.
//  Copyright © 2020 VooDooLab. All rights reserved.
//

import Foundation

// MARK: - View
protocol OperationsViewProtocol: class {
    func reload(rows: [Int])
    func reloadData(isRefreshing: Bool)
    func requestDidSend()
    func responseDidRecieve(completion: (() -> ())?)
    func dataRefreshed() 
}

// MARK: - Presenter
protocol OperationsPresenterProtocol: class {
    var operationsCount: Int { get }
    var operationsInfo: [OperationInfo?] { get }
    func loadPage(for row: Int)
    func viewDidLoad()
    func popView()
    func filterButtonPressed()
    func refreshData()
}

// MARK: - Router
protocol OperationsRouterProtocol {
    func popView()
    func presentFilterView(types: [OperationFilter]?,
                           periodFrom: Date?,
                           periodTo: Date?,
                           completion: (([OperationFilter]?, Date?, Date?) -> ())?)
}

// MARK: - Interactor
protocol OperationsInteractorProtocol: class {
    func getOperations(page: Int,
                       qty: Int,
                       types: [String]?,
                       periodFrom: String?,
                       periodTo: String?,
                       onSuccess: @escaping (UserOperationsResponse) -> (),
                       onFailure: @escaping () -> ()?)
}

// MARK: - Configurator
protocol OperationsConfiguratorProtocol {
    
}
