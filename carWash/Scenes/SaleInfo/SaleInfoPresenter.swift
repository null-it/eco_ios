//
//  SaleInfoPresenter.swift
//  carWash
//
//  Created by Juliett Kuroyan on 25.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//


class SaleInfoPresenter {
    
    unowned let view: SaleInfoViewProtocol
    var interactor: SaleInfoInteractorProtocol!
    let router: SaleInfoRouterProtocol
    
    init(view: SaleInfoViewProtocol,
         router: SaleInfoRouterProtocol) {
        self.view = view
        self.router = router
        
    }
    
}


extension SaleInfoPresenter: SaleInfoPresenterProtocol {
    
    func popView() {
        router.popView()
    }
    
}
