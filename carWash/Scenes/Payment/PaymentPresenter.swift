//
//  PaymentPresenter.swift
//  carWash
//
//  Created by Juliett Kuroyan on 27.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

class PaymentPresenter {
    
    unowned let view: PaymentViewProtocol
    var interactor: PaymentInteractorProtocol!
    let router: PaymentRouterProtocol
    
    var paymentTypes = [
        PaymentTypeInfo(title: "Картой в приложении"),
        PaymentTypeInfo(title: "Apple Pay")
    ]
    
    init(view: PaymentViewProtocol,
         router: PaymentRouterProtocol) {
        self.view = view
        self.router = router
        
    }
    
    
    
}


extension PaymentPresenter: PaymentPresenterProtocol {
    
    func viewDidLoad() {
        view.updateFor(info: paymentTypes)
    }
    
    
    func popView() {
        router.popView()
    }
    
}
