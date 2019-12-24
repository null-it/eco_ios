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
    
    func selectCity() {
        router.presentCityView()
    }
    
    
    private func didSelectWash(id: Int) {
        interactor.getWash(id: id, onSuccess: { [weak self] (response) in
            let address = response.address
            let cashback = "Кешбек: \(response.cashback)%"
            let sales = response.stocks
            self?.view.showInfo(address: address, cashback: cashback, sales: sales ?? [])
        }) {
            ()
        }
    }
    
    
    func presentSaleInfoView() {
        router.presentSaleInfoView()
    }
    
    
    func popView() {
        router.popView()
    }
    
    func viewDidLoad() {
        getWashes()
    }
    
    private func getWashes() {
        interactor.getWashes(city: nil, onSuccess: { (response) in
            response.washes.forEach { [weak self] (wash) in
                guard let self = self else { return }
//                let (lat, lon) = self.getCoordinates(from: wash.coordinates)
                let lat = wash.coordinates[0]
                let lon = wash.coordinates[1]
                self.view.set(latitude: lat,
                               longitude: lon) {
                                self.didSelectWash(id: wash.id)
                }
            }
        }) {
            () // alert
        }
    }
    
//    private func getCoordinates(from str: String) -> (Double, Double) {
//        let coordinates = str.split(separator: ",").map(String.init)
//        let latStr = coordinates[0]
//        var lonStr = coordinates[1]
//        lonStr.remove(at: lonStr.startIndex)
//        let lat = Double(latStr)!
//        let lon = Double(lonStr)!
//        return (lat, lon)
//    }
    
}

