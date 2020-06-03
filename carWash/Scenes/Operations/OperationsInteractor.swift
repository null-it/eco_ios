//
//  OperationsFilterInteractor.swift
//  carWash
//
//  Created by Juliett Kuroyan on 15.01.2020.
//  Copyright © 2020 VooDooLab. All rights reserved.
//

import Foundation

class OperationsInteractor {
    
    unowned var presenter: OperationsPresenterProtocol
    
    init(presenter: OperationsPresenterProtocol) {
        self.presenter = presenter
    }
    
}

// MARK: - OperationsInteractorProtocol

extension OperationsInteractor: OperationsInteractorProtocol {
    
    func getOperations(page: Int,
                       qty: Int,
                       types: [String]?,
                       periodFrom: String?,
                       periodTo: String?,
                       onSuccess: @escaping (UserOperationsResponse) -> (),
                       onFailure: @escaping () -> ()?) {
        let request = Request.User.Operations.Get(page: page,
                                                  qty: qty,
                                                  types: types,
                                                  periodFrom: periodFrom,
                                                  periodTo: periodTo)
        request.send().done { response in
            onSuccess(response)
        }.catch { error in
            print(error)
            onFailure()
        }
    }
    
}
