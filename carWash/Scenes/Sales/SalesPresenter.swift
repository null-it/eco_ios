//
//  SalesPresenter.swift
//  carWash
//
//  Created by Juliett Kuroyan on 25.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//
import SwiftKeychainWrapper

class SalesPresenter {
    
    // MARK: - Properties
    
    unowned let view: SalesViewProtocol
    var interactor: SalesInteractorProtocol!
    let router: SalesRouterProtocol
    var city = ""
    var sales: [SaleResponse?] = []
    
    var qty = 2
    var pagesTriedToLoad: [Int] = []
    var lastPage: Int?
    var salesCount = 0
    
    init(view: SalesViewProtocol,
         router: SalesRouterProtocol) {
        self.view = view
        self.router = router
    }
    
    // MARK: - Private
    
    private func initLoadingInfoIfNeeded() {
        let city = KeychainWrapper.standard.string(forKey: "city")
        guard city != self.city else { return }
        initLoadingInfo()
    }
    
    
    private func initLoadingInfo() {
        lastPage = nil
        sales = []
        salesCount = 0
        pagesTriedToLoad = []
    }
    
    
    private func page(for row: Int) -> Int {
        let page: Int = row / qty + 1
        return page
    }
    
    
    private func load(page: Int, isRefreshing: Bool = false) {
        
        let city = KeychainWrapper.standard.string(forKey: "city")
        
        guard !pagesTriedToLoad.contains(page) else {
            //            city != self.city else {
            return
        }
        
        if page == 1 {
//            if !isRefreshing {
                view.requestDidSend()
//            }
        }
        
        pagesTriedToLoad.append(page)
        
        if let lastPage = lastPage {
            guard page <= lastPage else {
                return
            }
        }
        
        let onSuccess: (SalesResponse) -> () = { [weak self] (response) in
            guard let self = self else {
                return
            }
            
            if page == 1 {
                self.sales = Array(repeating: nil, count: response.total)
                self.salesCount = response.total
                self.lastPage = response.lastPage
                if isRefreshing {
                    self.view.refreshDidEnd()
                } // else {
                    self.view.responseDidRecieve()
//                }
            }
            
            self.add(sales: response.data, page: page)
            self.reloadRows(for: page)
            self.city = city ?? ""
        }
    
        
        let onFailure = { [weak self] in
            if isRefreshing {
                self?.view.dataRefreshingError()
            }
            self?.view.responseDidRecieve()
            self?.view.showNetworkErrorMessage()
        }
        
        interactor.getSales(page: page,
                            qty: qty,
                            city: city,
                            onSuccess: onSuccess,
                            onFailure: onFailure)
        
    }
    
    
    private func add(sales: [SaleResponse],
                     page: Int) {
        if let indexes = range(for: page) {
            self.sales.replaceSubrange(indexes, with: sales)
        }
    }
    
    
    private func reloadRows(for page: Int) {
        guard let range = range(for: page) else {
            return
        }
        let rows = range.filter { _ in true }
        
        if page == 1 {
            view.reloadData(sales: sales)
        } else {
            view.reload(rows: rows, sales: sales)
        }
    }
    
    
    private func range(for page: Int) -> Range<Int>? {
        let startIndex = (page - 1) * qty
        let supposedEndIndex = startIndex + qty
        let endIndex = supposedEndIndex < salesCount
            ? supposedEndIndex
            : salesCount
        if startIndex > endIndex {
            return nil
        }
        let range = startIndex..<endIndex
        return range
    }
    
}


extension SalesPresenter: SalesPresenterProtocol {
    
    func selectCity() {
        router.presentCityView(cityChanged: nil)
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
    
    
    func refreshData() {
        initLoadingInfo()
        load(page: 1, isRefreshing: true)
        print("refreeeesh")
    }
    
    
    func viewDidLoad() {
        getSales()
    }
    
    
    func getSales() {
        initLoadingInfoIfNeeded()
        load(page: 1)
    }

    
    func presentSaleInfoView(row: Int) {
        guard let id = sales[row]?.id else { return }
        router.presentSaleInfoView(id: id)
    }
    
    
    func presentSaleInfoView(id: Int) {
         router.presentSaleInfoView(id: id)
    }
    
    
    func loadPage(for row: Int) {
        guard row < sales.count && row >= 0 else { return }
        if  sales[row] == nil {
            let pageForLoad = page(for: row)
            load(page: pageForLoad)
        }
    }
    
}
