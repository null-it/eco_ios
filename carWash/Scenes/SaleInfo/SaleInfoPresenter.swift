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
    var sale: SaleResponse?
    var id: Int! {
        didSet {
            getSaleInfo()
        }
    }
    
    
    init(view: SaleInfoViewProtocol,
         router: SaleInfoRouterProtocol) {
        self.view = view
        self.router = router
        
    }
    
    
    private func getSaleInfo() {
        interactor.getSale(id: id,
                           onSuccess: { [weak self] (sale) in
                            self?.view.updateInfo(sale: sale)
                            self?.sale = sale
        },
                           onFailure: {
                            // ! alert !
        })
        view.requestDidSend()
    }
}


extension SaleInfoPresenter: SaleInfoPresenterProtocol {
    
    func popView() {
        router.popView()
    }
    
    func addressButtonPressed(row: Int) {
        if let washId = sale?.washes?[row].id {
            router.presentMapView(washId: washId)
        }
    }
    
}
