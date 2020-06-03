//
//  PaymentInteractor.swift
//  carWash
//
//  Created by Juliett Kuroyan on 27.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//


class PaymentInteractor {
    
    unowned var presenter: PaymentPresenterProtocol
    
    init(presenter: PaymentPresenterProtocol) {
        self.presenter = presenter
    }
    
    
}

// MARK: - PaymentInteractorProtocol

extension PaymentInteractor: PaymentInteractorProtocol {
    
    func pay(amount: Int,
             onSuccess: @escaping (String) -> (),
             onFailure: (() -> ())?) {
        let request = Request.Pay.Post(amount: amount)
        request.send().done { response in
            onSuccess(response)
        }.catch { error in
            print(error)
            onFailure?()
        }
    }
    
}

