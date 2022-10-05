//
//  MainPresenter.swift
//  carWash
//
//  Created by Juliett Kuroyan on 18.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//
import SwiftKeychainWrapper

class MainPresenter {
    
    // MARK: - Properties
    
    unowned let view: MainViewProtocol
    var interactor: MainInteractorProtocol!
    let router: MainRouterProtocol
    
    init(view: MainViewProtocol,
         router: MainRouterProtocol) {
        self.view = view
        self.router = router
    }
    
    var operationsCount = 15
    var qty = 15
    var operationsInfo: [OperationInfo?] = []
    var name = ""
    var promocode = ""
    var cities: [CityResponse] = []
    var reviewText: [Int: String] = [:]
    var reviewRating: [Int: Double] = [:]
    var reviewOperationId: [Int: Int] = [:]
    
    // MARK: - Private
    private let userDefaultsStandart = UserDefaults.standard
    
    private func toRub(value: Int?) -> String {
        var balance = String(value ?? 0)
        balance += " ₽"
        return balance
    }
    
    
    private func toPercent(value: Int?) -> String {
        var percent = String(value ?? 0)
        percent += " %"
        return percent
    }
    
    
    private func checkNotification(notificationResponse: ReviewNotificationResponse?) {
        if let _ = KeychainWrapper.standard.string(forKey: "notification"),
            let notificationResponse = notificationResponse,
            notificationResponse.type == "review" {
            view.showReviewView(price: notificationResponse.price,
                                date: "",
                                address: notificationResponse.wash.address) // !
            KeychainWrapper.standard.removeObject(forKey: "notification")
        }
    }
    
    
    private func setCityIfNeeded() {
        if KeychainWrapper.standard.data(forKey: "city") == nil {
            interactor.getCities(onSuccess: { [weak self] (cities) in
                guard let self = self else { return }
                if !cities.isEmpty {
                    self.cities = cities
                    self.view.selectCity(cities: self.cities)
                }
                }, onFailure: nil)
        }
    }
    
    
    private func initLoadingInfo() {
        operationsInfo = []
        operationsCount = 0
    }
    
    
    private func getUserInfo() { // !
        view.userInfoRequestDidSend()
        interactor.getUserInfo(onSuccess: { [weak self] (response) in
            guard let self = self else { return }
            let data = response.data
            KeychainWrapper.standard.set(data.id, forKey: "userId")
            self.name = data.name ?? data.phone
            self.userDefaultsStandart.setValue(response.minReplenish, forKey: UserDefaultsKeys.minReplenish.rawValue)
            self.userDefaultsStandart.setValue(response.data.email, forKey: UserDefaultsKeys.email.rawValue)
            self.userDefaultsStandart.setValue(data.phone, forKey: UserDefaultsKeys.phone.rawValue)

            let balance = self.toRub(value: data.balance)
            if response.data.city != nil {
                KeychainWrapper.standard.set(response.data.city!, forKey: "city")
            }
            self.setCityIfNeeded()
            
            self.view.userInfoResponseDidRecieve() {
                
            }
            
            self.view.set(balance: balance, cardNumber: data.phone)
           
        }) {
            () // ! alert
        }
    }
    
}


// MARK: - MainPresenterProtocol

extension MainPresenter: MainPresenterProtocol {
    
    func shouldChangePromocodeCharacters(in range: NSRange, replacementString string: String) -> Bool {
        guard let textRange = Range(range, in: promocode) else {
            return false
        }
        promocode = promocode.replacingCharacters(in: textRange, with: string)
        promocode.count > 0 ? view.promocodeTyping() : view.promocodeFieldIsEmpty()
        return true
    }
    
    func sendPromocodeTapped() {
        view.requestSended()
        interactor.applyPromocode(promocode: promocode) { message, status in
            self.view.responseReceived()
            switch status {
            case .ok:
                self.view.showAlert(message: message, title: "Предупреждение")
            case .error:
                self.view.showAlert(message: message, title: "Ошибка")
            }
        } onFailure: {
            self.view.responseReceived()
            self.view.showAlert(message: "Ошибка", title: "")
        }
    }
    
    
    func refreshData() {
        initLoadingInfo()
        getOperations(isRefreshing: true)
        getUserInfo()
    }
    
    func allOperationsButtonPressed() {
        router.presentOperationsView()
    }
    
    
    func ratingDidChanged(index: Int, rating: Double) {
        reviewRating[index] = rating
    }
    
    
    func reviewDoneButtonPressed(index: Int) {
        
        guard let text = reviewText[index],
            let rating = reviewRating[index],
            let operationId = reviewOperationId[index],
            let userId = KeychainWrapper.standard.integer(forKey: "userId"),
//            !text.isEmpty,
            !rating.isZero else {
                view.showAlert(message: "Заполните все поля", title: "Ошибка")
                return
        }
        
        let onSuccess: (ReviewResponse) -> () = { [weak self] (response) in
            if response.status == "ok" {
                self?.view.hideInfoView()
            } else {
                let message = response.msg ?? "Не удалось отправить отзыв"
                self?.view.showAlert(message: message, title: "Ошибка")
            }
        }
        let onFailure = { [weak self] in
            self?.view.showAlert(message: "Не удалось отправить отзыв", title:  "Ошибка")
        }
        
        interactor.postReview(userId: userId,
                              operationId: operationId,
                              text: text.isEmpty ? "..." : text,
                              stars: rating,
                              onSuccess: onSuccess,
                              onFailure: onFailure)
    }
    
    
    func didChange(reviewRating: Double, index: Int) {
        self.reviewRating[index] = reviewRating
    }
    
    
    func didChange(reviewText: String, index: Int) {
        self.reviewText[index] = reviewText
        view.didChange(reviewText: reviewText, index: index)
    }
    
    
    func didRecieveNotification(_ notificationResponse: ReviewNotificationResponse?) {
        guard let notificationResponse = notificationResponse else { return }
        print(notificationResponse)
        let index = view.showReviewView(price: notificationResponse.price,
                                        date: "",
                                        address: notificationResponse.wash.address)
        reviewText[index] = ""
        reviewRating[index] = 0
        reviewOperationId[index] = notificationResponse.operationId
        
    }
    
    
    func didSelectCity(row: Int) {
        KeychainWrapper.standard.set(cities[row].city, forKey: "city") // !
        KeychainWrapper.standard.set(cities[row].coordinates[1], forKey: "cityLongitude")
        KeychainWrapper.standard.set(cities[row].coordinates[0], forKey: "cityLatitude")
        interactor.postCity(city: cities[row].city, onSuccess: {}, onFailure: {})
    }
    
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
    
    
    func viewDidLoad(notificationResponse: ReviewNotificationResponse?) {
        getUserInfo()
        getOperations()
        checkNotification(notificationResponse: notificationResponse)
    }
    
    
    
    func presentPaymentView() {
        router.presentPaymentView()
    }

    func getOperations(isRefreshing: Bool = false) {
        
        view.operationsRequestDidSend()
        let onSuccess: (UserOperationsResponse) -> () = { [weak self] (model) in
            guard let self = self else {
                return
            }
            
            let operations = model.data.map { [weak self] (model) -> OperationInfo in
                guard let self = self,
                    let type = OperationType(rawValue: model.type) else {
                        return OperationInfo()
                }
                var typeDescription = type.description()
                if let wash = model.wash {
                    typeDescription += " " + wash.address
                }
                var imageName: String
                switch type {
                case .replenish_online:
                    imageName = OperationType.waste.rawValue
                case .replenish_offline:
                    imageName = OperationType.waste.rawValue
                case .waste:
                    imageName = OperationType.replenish_online.rawValue
                case .cashback:
                    imageName = OperationType.cashback.rawValue
                }
                let title = typeDescription // !
                var sum = self.toRub(value: model.value)
                
                switch type {
                case .cashback:
                    ()
                case .replenish_online, .replenish_offline:
                    sum = "+ " + sum
                case .waste:
                    sum = "- " + sum
                }
                
                let info = OperationInfo(imageName: imageName,
                                         title: title,
                                         sum: sum,
                                         time: model.created_at)
                return info
            }
            self.operationsInfo = operations
            self.view.operationsResponseDidRecieve() {
                self.view.reloadData()
            }
            
            if isRefreshing {
                self.view.dataRefreshed()
            }
            
        }
        
        let onFailure = { [weak self] in
            if isRefreshing {
                self?.view.dataRefreshingError()
            }
            self?.view.showNetworkErrorMessage()
        }
        
        interactor.getOperations(page: 1,
                                 qty: qty,
                                 onSuccess: onSuccess,
                                 onFailure: onFailure)
    }
    
}

