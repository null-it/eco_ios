//
//  SalesPresenter.swift
//  carWash
//
//  Created by Juliett Kuroyan on 25.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//
import SwiftKeychainWrapper

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
    
    func selectCity() {
        router.presentCityView()
    }
    
    func logout() {
        view.showAlert(message: "Вы действительно хотите выйти?",
                       title: "Выход",
                       okButtonTitle: "Да",
                       cancelButtonTitle: "Нет",
                       okAction: { [weak self] in
                        self?.interactor.logout(onSuccess: { [weak self] in
                            self?.router.popToAuthorization()
                            KeychainWrapper.standard.removeAllKeys()
                        }) {
                            // alert
                        }
        }) {}
        
    }
    
    func viewDidLoad() {
        view.updateSales(sales: [])
        getSales()
    }
    
    private func getSales() {
        let city = KeychainWrapper.standard.string(forKey: "city")
        interactor.getSales(city: city,
                            onSuccess: { [weak self] (response) in
                                self?.view.updateSales(sales: response.data)
        }) {
            // alert - can't get sales
        }
    }
    
    func presentSaleInfoView() {
        router.presentSaleInfoView()
    }
    
}
