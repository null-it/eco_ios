//
//  MapPresenter.swift
//  carWash
//
//  Created by Juliett Kuroyan on 19.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//


class MapPresenter {
    
    unowned let view: MapViewProtocol
    var interactor: MapInteractorProtocol!
    let router: MapRouterProtocol
    var isAuthorized: Bool = false

    init(view: MapViewProtocol,
         router: MapRouterProtocol) {
        self.view = view
        self.router = router
    }
    
}


extension MapPresenter: MapPresenterProtocol {
    
    func didSelectPoint() {
        view.showInfo()
    }
    
    
    func presentSaleInfoView() {
        router.presentSaleInfoView()
    }
    
    
    func popView() {
        router.popView()
    }

}
