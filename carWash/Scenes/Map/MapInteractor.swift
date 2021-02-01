//
//  MapInteractor.swift
//  carWash
//
//  Created by Juliett Kuroyan on 19.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//


class MapInteractor {
    
    unowned var presenter: MapPresenterProtocol
    
    init(presenter: MapPresenterProtocol) {
        self.presenter = presenter
    }
    
    
}

// MARK: - MapInteractorProtocol

extension MapInteractor: MapInteractorProtocol {
    
    func getCities(onSuccess: @escaping () -> (),
                   onFailure: @escaping () -> ()?) {
        let request = Request.Cities.Get()
        request.send().done { _ in
            onSuccess()
        }.catch { error in
            print(error)
            onFailure()
        }
    }
    
    
    func logout(onSuccess: @escaping () -> (),
                onFailure: @escaping () -> ()?) {
        let request = Request.User.Logout.Get()
        request.send().done { _ in
            onSuccess()
        }.catch { error in
            print(error)
            onFailure()
        }
    }
    
    
    func getWashes(city: String?,
                   onSuccess: @escaping (WashesResponse) -> (),
                   onFailure: @escaping () -> ()?) {
        let request = Request.Wash.Get(city: city)
        request.send().done { response in
            onSuccess(response)
            
        }.catch { error in
            print(error)
            onFailure()
        }
    }
    
    
    func getWash(id: Int,
                 onSuccess: @escaping (WashResponse) -> (),
                 onFailure: @escaping () -> ()?) {
        let request = Request.Wash.Get(id: id)
        request.send().done { response in
            onSuccess(response)
        }.catch { error in
            print(error)
            onFailure()
        }
    }
    
    func startWash(code: String,
                   onSuccess: @escaping (WashStartResponse) -> (),
                   onFailure: @escaping () -> ()?) {
        let request = Request.Wash.Start.Post(code: code)
        request.send().done { response in
            onSuccess(response)
        }.catch { error in
            print(error)
            onFailure()
        }
    }
    
}
