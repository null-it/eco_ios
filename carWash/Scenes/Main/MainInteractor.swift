//
//  MainInteractor.swift
//  carWash
//
//  Created by Juliett Kuroyan on 18.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

class MainInteractor {
    
    unowned var presenter: MainPresenterProtocol
    
    init(presenter: MainPresenterProtocol) {
        self.presenter = presenter
    }
    
    
}

// MARK: - MainInteractorProtocol

extension MainInteractor: MainInteractorProtocol {
    
    func getUserInfo(onSuccess: @escaping (UserResponse) -> (),
                     onFailure: @escaping () -> ()?) {
        let request = Request.User.Get()
        request.send().done { response in
            onSuccess(response)
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
    
    
    func getOperations(page: Int,
                       qty: Int,
                       onSuccess: @escaping (UserOperationsResponse) -> (),
                       onFailure: @escaping () -> ()?) {
        let request = Request.User.Operations.Get(page: page, qty: qty)
        request.send().done { response in
            onSuccess(response)
        }.catch { error in
            print(error)
            onFailure()
        }
    }
    
    
    func changeName_(name: String,
                     onSuccess: @escaping (NameChangeResponse) -> (),
                     onFailure: @escaping () -> ()?) {
        let request = Request.User.Post(name: name)
        request.send().done { response in
            onSuccess(response)
        }.catch { error in
            print(error)
            onFailure()
        }
    }
    
    
    func getCities(onSuccess: @escaping ([CityResponse]) -> (),
                   onFailure: (() -> ())?) {
        let request = Request.Cities.Get()
        
        request.send().done { response in
            onSuccess(response.cities)
        }.catch { error in
            print(error)
            onFailure?()
        }
    }
    
}
