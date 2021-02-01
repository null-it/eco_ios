//
//  OperationsFilterPresenter.swift
//  carWash
//
//  Created by Juliett Kuroyan on 15.01.2020.
//  Copyright © 2020 VooDooLab. All rights reserved.
//

import Foundation

class OperationsPresenter {
    
    // MARK: - Properties
    
    unowned let view: OperationsViewProtocol
    var interactor: OperationsInteractorProtocol!
    let router: OperationsRouterProtocol
    
    var qty = 15
    var pagesTriedToLoad: [Int] = []
    var lastPage: Int?
    var operationsCount = 0
    var operationsInfo: [OperationInfo?] = []
    var types: [OperationFilter]?
    var periodFrom: Date?
    var periodTo: Date?
    
    
    // Lifecycle
    
    init(view: OperationsViewProtocol,
         router: OperationsRouterProtocol) {
        self.view = view
        self.router = router
    }
    

    // MARK: - Private
    
    private func getOperations(isRefreshing: Bool) {
        initLoadingInfo()
        load(page: 1, isRefreshing: isRefreshing)
        view.requestDidSend()
    }
    
    
    private func initLoadingInfo() {
        lastPage = nil
        operationsInfo = []
        operationsCount = 0
        pagesTriedToLoad = []
    }
    
    
    private func page(for row: Int) -> Int {
        let page: Int = row / qty + 1
        return page
    }
    
    
    private func load(page: Int, isRefreshing: Bool = false) {
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
            guard let self = self else { return }
            
            if page == 1 {
                self.operationsInfo = Array(repeating: nil, count: model.total)
                self.operationsCount = model.total
                self.lastPage = model.lastPage
                if isRefreshing {
                    self.view.dataRefreshed()
                }
            }
            
            let operations = model.data.map { [weak self] (model) -> OperationInfo in
                guard let self = self,
                    let type = OperationType.init(rawValue: model.type) else {
                        return OperationInfo()
                }
                let typeDescription = type.description()
                let imageName = type.rawValue
                let title = typeDescription
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
            
            self.add(operations: operations, page: page)
            if page != 1 {
                self.reloadRows(for: page, isRefreshing: isRefreshing)
            } else {
                self.view.responseDidRecieve() {
                    self.reloadRows(for: page, isRefreshing: isRefreshing)
                }
            }
            
        }
        
        let onFailure = {
            // ! alert
        }

        var periodFromStr = ""
        var periodToStr = ""
        if let periodTo = self.periodTo {
            periodToStr = format(date: periodTo)
        }
        if let periodFrom = self.periodFrom {
            periodFromStr = format(date: periodFrom)
        }
        
        
        var types = self.types?
            .map({ (operationFilter) -> String in
                return operationFilter.description()
            })
        
        if let isAll = types?.contains(OperationFilter.all.description()),
            isAll {
            types = nil
        }

        interactor.getOperations(page: page,
                                 qty: qty,
                                 types: types,
                                 periodFrom: periodFromStr,
                                 periodTo: periodToStr,
                                 onSuccess: onSuccess,
                                 onFailure: onFailure)
    }
    
    
    private func format(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
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
    
    
    private func reloadRows(for page: Int, isRefreshing: Bool) {
        guard let range = range(for: page) else {
            return
        }
        let rows = range.filter { _ in true }
        
        if page == 1 {
            view.reloadData(isRefreshing: isRefreshing)
        } else {
            view.reload(rows: rows)
        }
    }
    
    
    private func toRub(value: Int?) -> String {
        var balance = String(value ?? 0)
        balance += " ₽"
        return balance
    }
    
}

// MARK: - OperationsPresenterProtocol

extension OperationsPresenter: OperationsPresenterProtocol {
    
    func loadPage(for row: Int) {
        if row < operationsCount
            && operationsInfo[row] == nil {
            let pageForLoad = page(for: row)
            load(page: pageForLoad)
        }
    }
    
    
    func viewDidLoad() {
        getOperations(isRefreshing: false)
    }
    
    
    func refreshData() {
        getOperations(isRefreshing: true)
    }
    
    
    func popView() {
        router.popView()
    }
    
    
    func filterButtonPressed() {
        router.presentFilterView(types: types,
                                 periodFrom: periodFrom,
                                 periodTo: periodTo,
                                 completion: { [weak self] (operations, dateFrom, dateTo) in
                                    guard let self = self else { return }
                                    self.types = operations
                                    self.periodFrom = dateFrom
                                    self.periodTo = dateTo
                                    self.getOperations(isRefreshing: false)
        })
    }
    
}
