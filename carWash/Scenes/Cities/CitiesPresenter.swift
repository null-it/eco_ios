//
//  LogimPresenter.swift
//  carWash
//
//  Created by Juliett Kuroyan on 26.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper


class CitiesPresenter {

    // MARK: - Properties
    
    unowned let view: CitiesViewProtocol
    var interactor: CitiesInteractorProtocol!
    let router: CitiesRouterProtocol
    
    var cities: [String]!
    var coordinates: [[Double]]!
    
    var titles = ["Текущий город", "Список городов"]
    var currentCity: String = KeychainWrapper.standard.string(forKey: "city")! 
    var cityChanged: (() -> ())?
    
    // MARK: - Lifecycle
    
    init(view: CitiesViewProtocol,
         router: CitiesRouterProtocol) {
        self.view = view
        self.router = router
    }
    
}


// MARK: - CitiesPresenterProtocol

extension CitiesPresenter: CitiesPresenterProtocol {
    
    func didSelectCity(row: Int, isCurrent: Bool) {
        if !isCurrent {
            KeychainWrapper.standard.set(cities[row], forKey: "city")
            KeychainWrapper.standard.set(coordinates[row][1], forKey: "cityLongitude")
            KeychainWrapper.standard.set(coordinates[row][0], forKey: "cityLatitude")
            interactor.postCity(city: cities[row], onSuccess: {}, onFailure: {})
            cityChanged?()
        }
        popView()
    }
    
    
    func popView() {
        router.popView()
    }
    
    
    func viewDidLoad() {
        view.requestDidSend()
        interactor.getCities(onSuccess: { [weak self] (response) in
            guard let self = self else { return }
            self.view.responseDidRecieve()
            let filteredResponse = response.filter {
                $0.city != self.currentCity
            }
            
            self.cities = filteredResponse
                .map { $0.city }
            self.coordinates = filteredResponse
                .map { $0.coordinates }
            
            self.view.update(currentCity: self.currentCity,
                             cities: self.cities,
                             titles: self.titles)
        }) {
            // alert
            self.view.responseDidRecieve()
        }
    }
    
}
