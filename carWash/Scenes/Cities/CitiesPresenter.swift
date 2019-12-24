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
    var titles = ["Текущий город", "Список городов"] // !
    var currentCity: String = KeychainWrapper.standard.string(forKey: "city")! // !
    
    // MARK: - Lifecycle
    
    init(view: CitiesViewProtocol,
         router: CitiesRouterProtocol) {
        self.view = view
        self.router = router
    }
    
}


// MARK: - CitiesPresenterProtocol

extension CitiesPresenter: CitiesPresenterProtocol {
    
    func didSelectCity(row: Int) {
        KeychainWrapper.standard.set(cities[row], forKey: "city")
        popView()
    }
    
    
    func popView() {
        router.popView()
    }
    
    
    func viewDidLoad() {
        interactor.getCities(onSuccess: { [weak self] (response) in
            guard let self = self else { return }
            self.cities = response
                .map { $0.city }
                .filter({ [weak self] (city) -> Bool in
                    city != self?.currentCity
                })
            self.view.update(currentCity: self.currentCity,
                             cities: self.cities,
                             titles: self.titles) // !
            
        }) {
            // alert
        }
    }
    
}
