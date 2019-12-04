//
//  SalesPresenter.swift
//  carWash
//
//  Created by Juliett Kuroyan on 25.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//


class SalesPresenter {
    
    unowned let view: SalesViewProtocol
    var interactor: SalesInteractorProtocol!
    let router: SalesRouterProtocol
    
    init(view: SalesViewProtocol,
         router: SalesRouterProtocol) {
        self.view = view
        self.router = router
        
    }
    
}


extension SalesPresenter: SalesPresenterProtocol {
    
    func presentSaleInfoView() {
        router.presentSaleInfoView()
    }
    
}
