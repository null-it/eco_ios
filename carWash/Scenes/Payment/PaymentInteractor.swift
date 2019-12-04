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
    
    
}

