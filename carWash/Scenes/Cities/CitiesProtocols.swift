//
//  CitiesProtocols.swift
//  carWash
//
//  Created by Juliett Kuroyan on 26.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import Foundation


// MARK: - View
protocol CitiesViewProtocol: class {
    func update(currentCity: String, cities: [String], titles: [String])
    func requestDidSend() 
    func responseDidRecieve()
}


// MARK: - Presenter
protocol CitiesPresenterProtocol: class {
    func popView()
    func viewDidLoad()
    func didSelectCity(row: Int, isCurrent: Bool)    
}


// MARK: - Router
protocol CitiesRouterProtocol {
    func popView()
}


// MARK: - Interactor
protocol CitiesInteractorProtocol: class {
    func getCities(onSuccess: @escaping ([CityResponse]) -> (),
                   onFailure: @escaping () -> ()?)
    func postCity(city: String,
                     onSuccess: @escaping () -> (),
                     onFailure: @escaping () -> ()?)
}


// MARK: - Configurator
protocol CitiesConfiguratorProtocol {
    
}
