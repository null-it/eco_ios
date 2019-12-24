//
//  MainPresenter.swift
//  carWash
//
//  Created by Juliett Kuroyan on 18.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//
import SwiftKeychainWrapper


enum OperationType: String {
    case waste //= "Cписание"
    case replenish_online //= "Пополнение онлайн"
    case replenish_offline //= "Пополнение оффлайн"
    case cashback //= "Кэшбэк"
    
    func description() -> String {
        switch self {
        case .waste:
            return "Cписание"
        case .replenish_online:
            return "Пополнение онлайн"
        case .replenish_offline:
            return "Пополнение оффлайн"
        case .cashback:
            return "Кэшбэк"
        }
    }
}

struct OperationInfo {
    var imageName: String = ""
    var title: String = ""
    var sum: String = ""
}


class MainPresenter {
    
    unowned let view: MainViewProtocol
    var interactor: MainInteractorProtocol!
    let router: MainRouterProtocol
    
    init(view: MainViewProtocol,
         router: MainRouterProtocol) {
        self.view = view
        self.router = router
    }
    
    var qty = 10
    var pagesTriedToLoad: [Int] = []
    var lastPage: Int?
    var operationsCount = 0
    var operationsInfo: [OperationInfo?] = []
    var name = ""
    var cities: [CityResponse] = []
}


extension MainPresenter: MainPresenterProtocol {
    
    func didSelectCity(row: Int) {
        KeychainWrapper.standard.set(cities[row].city, forKey: "city") // !
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
    
    
    func viewDidLoad() {
        getUserInfo()
        getOperations()
        setCityIfNeeded()
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
    
    
    func getOperations() {
        initLoadingInfo()
        load(page: 1)
    }
    
    
    private func initLoadingInfo() {
        lastPage = nil
        operationsInfo = []
        operationsCount = 0
        pagesTriedToLoad = []
    }
    
    
    private func getUserInfo() { // !
        interactor.getUserInfo(onSuccess: { [weak self] (response) in
            guard let self = self else { return }
            let data = response.data
            self.name = data.name ?? data.phone
            if let _ = data.name {
                self.view.configureTextFieldForName()
            } else {
                self.view.configureTextFieldForPhone()
            }
            let balance = self.toRub(value: data.balance)
            self.view.set(name: self.name, balance: balance)
            
            let firstPercent = self.toPercent(value: response.month_cash_back[0].percent)
            let firstValue = self.toRub(value: response.month_cash_back[0].value)
            let secondPercent = self.toPercent(value: response.month_cash_back[1].percent)
            let secondValue =  self.toRub(value: response.month_cash_back[1].value)
            let thirdPercent = self.toPercent(value: response.month_cash_back[2].percent)
            let thirdValue =  self.toRub(value: response.month_cash_back[2].value)
            let fourthPercent = self.toPercent(value: response.month_cash_back[3].percent)
            let fourthValue =  self.toRub(value: response.month_cash_back[3].value)
            let fifthPercent = self.toPercent(value: response.month_cash_back[4].percent)
            let fifthValue =  self.toRub(value: response.month_cash_back[4].value)
                
            self.view.setCahbackInfo(firstPercent: firstPercent, firstValue: firstValue,
                                     secondPercent: secondPercent, secondValue: secondValue,
                                     thirdPercent: thirdPercent, thirdValue: thirdValue,
                                     fourthPercent: fourthPercent, fourthValue: fourthValue,
                                     fifthPercent: fifthPercent, fifthValue: fifthValue)
                                    
            let distance: Float = 1 / Float(response.month_cash_back.count - 1)
            
            var nextCashbackIndex = 0
            while (nextCashbackIndex <= 4)
                && (response.month_cash_back[nextCashbackIndex].value < response.data.month_spent) {
                nextCashbackIndex += 1
            }
            
            let nextCashbackProgress = Float(nextCashbackIndex) * distance
            
            let currentCashbackProgress = nextCashbackProgress - distance
            let currentCashbackIndex = nextCashbackIndex - 1

            var description = ""
            if nextCashbackIndex >= 0 && nextCashbackIndex <= 4 { // ! other messages
                let value = response.month_cash_back[nextCashbackIndex].value - response.data.month_spent
                description = "До следующего уровня осталось потратить \(value) ₽"
            }
            
            let currentCashback = response.month_cash_back[currentCashbackIndex].value
            let difference = response.data.month_spent - currentCashback
            
            let nextCashback: Int?
            var sectionProgress: Float = 1
            
            if nextCashbackIndex <= 4 {
                nextCashback = response.month_cash_back[nextCashbackIndex].value
                sectionProgress = Float(difference) / Float(nextCashback! - currentCashback)
            }
            
            let progress = sectionProgress * distance + currentCashbackProgress

            self.view.updateCashbacks(progress: progress,
                                      currentCashbackProgress: currentCashbackProgress.isLess(than: 0) ? nil : currentCashbackProgress,
                                      nextCashbackProgress: !nextCashbackProgress.isLess(than: 1) ? nil : nextCashbackProgress,
                                      currentCashbackIndex: currentCashbackIndex < 0 ? nil : currentCashbackIndex,
                                      description: description)
        }) {
            () // ! alert
        }
    }
    
    
    
    func presentPaymentView() {
        router.presentPaymentView()
    }
    
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
    
    func loadPage(for row: Int) {
        if operationsInfo[row] == nil {
            let pageForLoad = page(for: row)
            load(page: pageForLoad)
        }
    }
    
    private func page(for row: Int) -> Int {
        let page: Int = row / qty + 1
        return page
    }
    
    private func load(page: Int) {
        guard !pagesTriedToLoad.contains(page) else {
            return
        }
        pagesTriedToLoad.append(page)
        
        if let lastPage = lastPage {
            guard page <= lastPage else {
                return
            }
        }
        
        let onSuccess: (UserOperationsResponse) -> () = { [weak self] (model) in
            guard let self = self else {
                return
            }
            
            if page == 1 {
                self.operationsInfo = Array(repeating: nil, count: model.total)
                self.operationsCount = model.total
                self.lastPage = model.last_page
            }
            
            let operations = model.data.map { [weak self] (model) -> OperationInfo in
                guard let self = self,
                    let type = OperationType.init(rawValue: model.type) else {
                        return OperationInfo()
                }
                let typeDescription = type.description()
                let imageName = type.rawValue
                let title = typeDescription // !
                let sum = self.toRub(value: model.value)
                let info = OperationInfo(imageName: imageName,
                                         title: title,
                                         sum: sum)
                return info
            }
            self.add(operations: operations, page: page)
            self.reloadRows(for: page)
            
        }
        
        let onFailure = {
            // ! alert
        }
        
        interactor.getOperations(page: page,
                                 qty: qty,
                                 onSuccess: onSuccess,
                                 onFailure: onFailure)
        
    }
    
    
    private func add(operations: [OperationInfo],
                     page: Int) {
        if let indexes = range(for: page) {
            self.operationsInfo.replaceSubrange(indexes, with: operations)
        }
    }
    
    
    private func range(for page: Int) -> Range<Int>? {
        let startIndex = (page - 1) * qty
        let supposedEndIndex = startIndex + qty
        let endIndex = supposedEndIndex < operationsCount
            ? supposedEndIndex
            : operationsCount
        if startIndex > endIndex {
            return nil
        }
        let range = startIndex..<endIndex
        return range
    }
    
    
    private func reloadRows(for page: Int) {
        guard let range = range(for: page) else {
            return
        }
        let rows = range.filter { _ in true }
        
        if page == 1 {
            view.reloadData()
        } else {
            view.reload(rows: rows)
        }
    }
    
}

