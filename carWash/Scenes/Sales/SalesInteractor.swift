//
//  SalesInteractor.swift
//  carWash
//
//  Created by Juliett Kuroyan on 25.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import SwiftKeychainWrapper

class SalesInteractor {
    
    unowned var presenter: SalesPresenterProtocol
    
    init(presenter: SalesPresenterProtocol) {
        self.presenter = presenter
    }
    
    
}

// MARK: - SalesInteractorProtocol

extension SalesInteractor: SalesInteractorProtocol {
    
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
    
    
    func getSales(page: Int,
                  qty: Int?,
                  city: String?,
                  onSuccess: @escaping (SalesResponse) -> (),
                  onFailure: @escaping () -> ()?) {
        let request = Request.Sale.Get(page: page, qty: qty, city: city)
        
        request.send().done { response in
            onSuccess(response)
        }.catch { error in
            print(error)
            onFailure()
        }
    }
    
}
