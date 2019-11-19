//
//  MainPresenter.swift
//  carWash
//
//  Created by Juliett Kuroyan on 18.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

class MainPresenter {
    
    unowned let view: MainViewProtocol
    var interactor: MainInteractorProtocol!
    let router: MainRouterProtocol
    
    init(view: MainViewProtocol,
         router: MainRouterProtocol) {
        self.view = view
        self.router = router
        
    }
    
}


extension MainPresenter: MainPresenterProtocol {
    
}
