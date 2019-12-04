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
    var cashbacks = [ // !
        CashbackTypeInfo(groups: [.available], title: "5%"),
        CashbackTypeInfo(groups: [.available], title: "10%"),
        CashbackTypeInfo(groups: [.available], title: "15%"),
        CashbackTypeInfo(groups: [.current], title: "20%"),
        CashbackTypeInfo(groups: [], title: "25%")
    ]
    
    init(view: MainViewProtocol,
         router: MainRouterProtocol) {
        self.view = view
        self.router = router
    }
    
}


extension MainPresenter: MainPresenterProtocol {
 
    func logout() {
        // ..
        router.popToAuthorization()
    }
    
    
    func viewDidLoad() {
        view.updateFor(info: cashbacks)
    }
    
    
    func presentPaymentView() {
        router.presentPaymentView()
    }
    
}
