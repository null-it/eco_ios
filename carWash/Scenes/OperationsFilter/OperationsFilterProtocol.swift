//
//  OperationsFilterProtocol.swift
//  carWash
//
//  Created by Juliett Kuroyan on 15.01.2020.
//  Copyright © 2020 VooDooLab. All rights reserved.
//

import Foundation

// MARK: - View
protocol OperationsFilterViewProtocol: class {
    func setMarker(operations: [OperationFilter])
    func setDate(from: String, date: Date?)
    func setDate(to: String, date: Date?)
}


// MARK: - Presenter
protocol OperationsFilterPresenterProtocol: class {
    func popView()
    func viewWillAppear()
    func operationTypeDidChange(operation: OperationFilter)
    func fromDateChanged(date: Date)
    func toDateChanged(date: Date)
    func filterButtonPressed()
    func clearFields()
}


// MARK: - Router
protocol OperationsFilterRouterProtocol {
    func popView()
}


// MARK: - Configurator
protocol OperationsFilterConfiguratorProtocol {}
