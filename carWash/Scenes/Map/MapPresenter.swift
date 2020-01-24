//
//  MapPresenter.swift
//  carWash
//
//  Created by Juliett Kuroyan on 19.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//
import SwiftKeychainWrapper

class MapPresenter {
    
    // MARK: - Properties
    
    unowned let view: MapViewProtocol
    var interactor: MapInteractorProtocol!
    let router: MapRouterProtocol
    var isAuthorized: Bool = false
    var washes: [WashResponse] = []
    var sales: [StockResponse]?
    var selectedWashId: Int?
    var washId: Int?
    
    init(view: MapViewProtocol,
         router: MapRouterProtocol) {
        self.view = view
        self.router = router
    }
    
    
    // MARK: - Private
        
    private func getWashes() {
        view.requestDidSend()
        interactor.getWashes(city: nil, onSuccess: { [weak self] (response) in
            self?.washes = response.washes
            response.washes.forEach { [weak self] (wash) in
                guard let self = self else { return }
                let lat = wash.coordinates[0]
                let lon = wash.coordinates[1]
                self.view.responseDidRecieve()
                self.view.set(latitude: lat,
                              longitude: lon,
                              id: wash.id,
                              cashbackText: "\(wash.cashback)%") {
                                self.selectedWashId = wash.id
                                self.didSelectWash(id: wash.id)
                }
                
                let latitude = KeychainWrapper.standard.double(forKey: "cityLatitude")
                let longitude = KeychainWrapper.standard.double(forKey: "cityLongitude")
                if latitude == nil,
                    longitude == nil,
                    self.washId == nil,
                    let wash =  self.washes.first {
                    self.view.configureDefaultMode(latitude: wash.coordinates[0], longitude: wash.coordinates[1])
                    KeychainWrapper.standard.set(wash.city, forKey: "city")
                }
            }
            if let washId = self?.washId {
                self?.view.selectWash(id: washId)
            }
        }) { [weak self] in
            self?.view.responseDidRecieve()
            // alert
        }
    }
    
    
    private func didSelectWash(id: Int) {
        interactor.getWash(id: id, onSuccess: { [weak self] (response) in
            let address = response.address
            var cashback = "Кешбек: \(response.cashback)%"
            if response.cashback == 0 {
                cashback = "Нет кешбека"
            }
            
            let sales = response.stocks
            self?.sales = sales
            self?.view.showInfo(address: address, cashback: cashback, sales: sales ?? [])
        }) {
            ()
        }
    }
    
}


// MARK: - MapPresenterProtocol

extension MapPresenter: MapPresenterProtocol {
    
    func selectCity(cityChanged: (() -> ())?) {
        router.presentCityView(cityChanged: cityChanged)
    }
    
    func logout() { // !
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
    
    func presentSaleInfoView(row: Int) {
        if let saleId =  sales?[row].id {
            router.presentSaleInfoView(id: saleId)
        }
    }
    
    
    func popView() {
        router.popView()
    }
    
    func viewDidLoad() {
        getWashes()
        if washId != nil {
            view.configureSelectedWashMode()
        }
    }
    
    func viewWillAppear() {
        if washId == nil  {
            if let latitude = KeychainWrapper.standard.double(forKey: "cityLatitude"),
                let longitude = KeychainWrapper.standard.double(forKey: "cityLongitude") {
                view.configureDefaultMode(latitude: latitude, longitude: longitude)
            }
        }
    }
    
}

