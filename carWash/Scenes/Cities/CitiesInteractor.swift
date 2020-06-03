//
//  CitiesInteractor.swift
//  carWash
//
//  Created by Juliett Kuroyan on 26.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

class CitiesInteractor {
    
    unowned var presenter: CitiesPresenterProtocol
    
    init(presenter: CitiesPresenterProtocol) {
        self.presenter = presenter
    }
    
    
}

// MARK: - CitiesInteractorProtocol

extension CitiesInteractor: CitiesInteractorProtocol {
    
    func getCities(onSuccess: @escaping ([CityResponse]) -> (),
                   onFailure: @escaping () -> ()?) {
        let request = Request.Cities.Get()
        
        request.send().done { response in
            onSuccess(response.cities)
        }.catch { error in
            print(error)
            onFailure()
        }
    }
    
    func postCity(city: String,
                  onSuccess: @escaping () -> (),
                  onFailure: @escaping () -> ()?) {
        let request = Request.User.SetCity.Post(city: city)
        
        request.send().done { response in
            onSuccess()
        }.catch { error in
            print(error)
            onFailure()
        }
    }
    
}

