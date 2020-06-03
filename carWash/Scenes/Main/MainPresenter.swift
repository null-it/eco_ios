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
    var cities: [CityResponse] = []
    var reviewText: [Int: String] = [:]
    var reviewRating: [Int: Double] = [:]
    var reviewOperationId: [Int: Int] = [:]
    
    // MARK: - Private
    
    
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

            let balance = self.toRub(value: data.balance)
            if !response.data.city.isEmpty {
                KeychainWrapper.standard.set(response.data.city, forKey: "city")
            }
            self.setCityIfNeeded()
            
            let firstPercent = self.toPercent(value: response.monthCashBack[0].percent)
            let firstValue = self.toRub(value: response.monthCashBack[0].value)
            let secondPercent = self.toPercent(value: response.monthCashBack[1].percent)
            let secondValue =  self.toRub(value: response.monthCashBack[1].value)
            let thirdPercent = self.toPercent(value: response.monthCashBack[2].percent)
            let thirdValue =  self.toRub(value: response.monthCashBack[2].value)
            let fourthPercent = self.toPercent(value: response.monthCashBack[3].percent)
            let fourthValue =  self.toRub(value: response.monthCashBack[3].value)
            let fifthPercent = self.toPercent(value: response.monthCashBack[4].percent)
            let fifthValue =  self.toRub(value: response.monthCashBack[4].value)
            
            
            let distance: Float = 1 / Float(response.monthCashBack.count - 1)
            
            var nextCashbackIndex = 0
            while (nextCashbackIndex <= 4)
                && (response.monthCashBack[nextCashbackIndex].value <= response.data.monthSpent) {
                    nextCashbackIndex += 1
            }
            
            let nextCashbackProgress = Float(nextCashbackIndex) * distance
            
            let currentCashbackProgress = nextCashbackProgress - distance
            let currentCashbackIndex = nextCashbackIndex - 1
            
            var description = ""
            if nextCashbackIndex >= 0 && nextCashbackIndex <= 4 { // ! other messages
                let value = response.monthCashBack[nextCashbackIndex].value - response.data.monthSpent
                description = "До следующего уровня осталось потратить \(value) ₽"
            } else if nextCashbackIndex == 5 {
                description = "Вы достигли максимально допустимого процента по кэшбеку"
            }
            
            var currentCashback = 0
            if currentCashbackIndex > 0 {
                currentCashback = response.monthCashBack[currentCashbackIndex].value
            }
            let difference = response.data.monthSpent - currentCashback
            
            let nextCashback: Int?
            var sectionProgress: Float = 1
            
            if nextCashbackIndex <= 4 {
                nextCashback = response.monthCashBack[nextCashbackIndex].value
                sectionProgress = Float(difference) / Float(nextCashback! - currentCashback)
            }
            
            let progress = sectionProgress * distance + currentCashbackProgress
            
            self.view.userInfoResponseDidRecieve() {
                self.view.updateCashbacks(progress: progress,
                                          currentCashbackProgress: currentCashbackProgress.isLess(than: 0) ? nil : currentCashbackProgress,
                                          nextCashbackProgress: !nextCashbackProgress.isLess(than: 1) ? nil : nextCashbackProgress,
                                          currentCashbackIndex: currentCashbackIndex < 0 ? nil : currentCashbackIndex,
                                          description: description)
            }
            
            if let _ = data.name {
                self.view.configureTextFieldForName()
            } else {
                self.view.configureTextFieldForPhone()
            }
            self.view.set(name: self.name, balance: balance)

            self.view.setCahbackInfo(firstPercent: firstPercent, firstValue: firstValue,
                                     secondPercent: secondPercent, secondValue: secondValue,
                                     thirdPercent: thirdPercent, thirdValue: thirdValue,
                                     fourthPercent: fourthPercent, fourthValue: fourthValue,
                                     fifthPercent: fifthPercent, fifthValue: fifthValue)
           
        }) {
            () // ! alert
        }
    }
    
}


// MARK: - MainPresenterProtocol

extension MainPresenter: MainPresenterProtocol {
    
    func refreshData() {
        initLoadingInfo()
        view.clearUserInfo()
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
    
    
    func nameEditindDidEnd(_ name: String?) {
        if let name = name,
            name != self.name {
            view.configureTextFieldForName()
            interactor.changeName_(name: name,
                                   onSuccess: { (response) in
                                    if response.status == "ok" {
                                        // ...
                                    } else {
                                        // alert response.errors?.name.first!
                                    }
            }) {
                // ! alert !
            }
        }
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
                let typeDescription = type.description()
                let imageName = type.rawValue
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

