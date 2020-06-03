//
//  MapPresenter.swift
//  carWash
//
//  Created by Juliett Kuroyan on 19.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//
import SwiftKeychainWrapper
import CoreLocation

class MapPresenter {
    
    // MARK: - Properties
    
    unowned let view: MapViewProtocol
    var interactor: MapInteractorProtocol!
    let router: MapRouterProtocol
    var isAuthorized: Bool = false 
    var isWashingStart: Bool = false
    var washes: [WashResponse] = []
    var sales: [StockResponse]?
    var selectedWash: WashResponse?
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
            guard let self = self else { return }
            self.washes = response.washes
            if self.isWashingStart {
                self.view.detectLocation()
            }
            response.washes.forEach { [weak self] (wash) in
                guard let self = self else { return }
                let lat = wash.coordinates[0]
                let lon = wash.coordinates[1]
                self.view.responseDidRecieve()
                self.view.set(latitude: lat,
                              longitude: lon,
                              id: wash.id,
                              cashbackText: "\(wash.cashback)%") {
                                if self.isWashingStart {
                                    self.view.configureWashingStartView()
                                } else {
                                    self.view.configureWashInfoView()
                                }
                                self.selectedWash = wash
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
            if let washId = self.washId {
                self.view.selectWash(id: washId)
            }
        }) { [weak self] in
            self?.view.responseDidRecieve()
            // alert
        }
    }
    
    
    private func didSelectWash(id: Int) {
        interactor.getWash(id: id, onSuccess: { [weak self] (response) in
            guard let self = self else { return }
            let address = response.address
            var cashback = "Кешбек: \(response.cashback)%"
            if response.cashback == 0 {
                cashback = "Нет кешбека"
            }
            var happyTimesText = ""
            var isHappyTimesHidden = true
            if let happyHours = response.happyHours{
                happyTimesText = "с \(happyHours.start) до \(happyHours.end)"
                isHappyTimesHidden = !happyHours.isEnabled
            }
            let sales = response.stocks
            self.sales = sales
            
            if self.isWashingStart {
                self.view.showWashingStartInfo(address: address,
                                               terminalsCount: 10) // !
            } else {
                self.view.showWashInfo(address: address,
                                       cashback: cashback,
                                       sales: sales ?? [],
                                       happyTimesText: happyTimesText,
                                       isHappyTimesHidden: isHappyTimesHidden)
            }
            

        }) {
            ()
        }
    }
    
    
}


// MARK: - MapPresenterProtocol

extension MapPresenter: MapPresenterProtocol {
    
    func didSelectTerminal(index: Int, address: String) {
        view.showConfirmationView(address: "\(address), терминал №\(index + 1)") { [weak self] in
            guard let self = self else { return }
            let systemId = self.selectedWash?.systemId ?? ""
            let code = systemId + "-" + String(index) // !!!!!!!!!!!!!!
            
            let onSuccess: (WashStartResponse) -> () = { [weak self] (wash) in
                switch wash.status {
                case "ok":
                    self?.view.setSucceeded(message: QRConstants.defaultSucceededMessage)
                default:
                    let message = wash.msg ?? QRConstants.defaultErrorMessage
                    self?.view.setError(message: message)
                }
            }
            
            let onFailure: () -> ()? = { [weak self] in
                self?.view.setError(message: QRConstants.defaultErrorMessage)
            }

            self.interactor.startWash(code: code,
                                 onSuccess: onSuccess,
                                 onFailure: onFailure)
        }
    }

    func didReceiveUserLocation(lat: Double, lon: Double) {
        var distance: Double?
        var nearestWash: WashResponse?
        
        let location = CLLocation(latitude: lat, longitude: lon)
        
        washes.forEach { (wash) in
            let washLat = wash.coordinates[0]
            let washLon = wash.coordinates[1]
            let washLocation = CLLocation(latitude: washLat, longitude: washLon)
            let currentDistance = washLocation.distance(from: location)

            if distance == nil || currentDistance < distance! {
                distance = currentDistance
                nearestWash = wash
            }
        }
        
        if let wash = nearestWash {
            view.showAlert(message: "Вы находитесь на мойке по адресу \(wash.address)?",
                title: "Подтверждение",
                okButtonTitle: "Да",
                cancelButtonTitle: "Нет",
                okAction: { [weak self] in
                    self?.view.startWash(id: wash.id) 
            }) { [weak self] in
                self?.view.select(latitude: lat, longitude: lon, locationDelta: nil)
                self?.view.showMessage(text: "Выберите нужную мойку")
            }
        }
        
    }
    
    
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
