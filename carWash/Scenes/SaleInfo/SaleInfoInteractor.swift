//
//  SaleInfoInteractor.swift
//  carWash
//
//  Created by Juliett Kuroyan on 25.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

class SaleInfoInteractor {
    
    unowned var presenter: SaleInfoPresenterProtocol
    
    init(presenter: SaleInfoPresenterProtocol) {
        self.presenter = presenter
    }
    
    
}

// MARK: - SaleInfoInteractorProtocol

extension SaleInfoInteractor: SaleInfoInteractorProtocol {
    
    func getSale(id: Int,
                 onSuccess: @escaping (SaleResponse) -> (),
                 onFailure: @escaping () -> ()?) {
        let request = Request.Sale.Get(id: id)
        
        request.send().done { response in
            onSuccess(response)
        }.catch { error in
            print(error)
            onFailure()
        }
    }
    
}
