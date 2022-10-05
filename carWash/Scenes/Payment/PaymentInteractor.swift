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
             email: String,
             phone: String,
             token: String,
             paymentType: PaymentType,
             onSuccess: @escaping (String?) -> (),
             onFailure: (() -> ())?) {
        let request = Request.Pay.Post(token: token, amount: amount, email: email, paymentType: paymentType)
        request.send().done { response in
            onSuccess(response.data.url)
        }.catch { error in
            print(error)
            onFailure?()
        }
    }
    
    func applyPromocode(promocode: String, onSuccess: @escaping (String, PromocodeStatus) -> (), onFailure: (() -> ())?) {
        let request = Request.Promocode.Post(promocode: promocode)
        request.send().done { (response) in
            onSuccess(response.message, response.status)
        }.catch { (error) in
            print(error.localizedDescription)
            onFailure?()
        }
    }
    
}

