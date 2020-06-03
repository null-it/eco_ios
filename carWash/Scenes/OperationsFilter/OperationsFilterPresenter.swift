//
//  OperationsFilterPresenter.swift
//  carWash
//
//  Created by Juliett Kuroyan on 15.01.2020.
//  Copyright © 2020 VooDooLab. All rights reserved.
//

import Foundation


class OperationsFilterPresenter {
    
    // MARK: - Properties
    
    unowned let view: OperationsFilterViewProtocol
    let router: OperationsFilterRouterProtocol
    
    var operations: [OperationFilter]?
    var periodFrom: Date?
    var periodTo: Date?
    var completion: (([OperationFilter]?, Date?, Date?) -> ())?
    
    
    // MARK: - Lifecycle
    
    init(view: OperationsFilterViewProtocol,
         router: OperationsFilterRouterProtocol) {
        self.view = view
        self.router = router
    }
    
    
    // MARK: - Private
    
    private func format(date: Date) -> String { // move to presenter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
    
}


// MARK: -  OperationsFilterPresenterProtocol

extension OperationsFilterPresenter: OperationsFilterPresenterProtocol {
    
    func clearFields() {
        periodTo = nil
        periodFrom = nil
        operations = OperationFilter.allCases()
        view.setDate(from: "",
                     date: nil)
        view.setDate(to: "",
                     date: nil)
        view.setMarker(operations: operations!)
        
    }
    
    
    func filterButtonPressed() {
        router.popView()
        completion?(operations, periodFrom, periodTo)
    }
    
    
    func fromDateChanged(date: Date) {
        periodFrom = date
        view.setDate(from: format(date: date),
                     date: date)
    }
    
    
    func toDateChanged(date: Date) {
        periodTo = date
        view.setDate(to: format(date: date),
                     date: date)
    }
    
    
    func popView() {
        router.popView()
    }
    
    
    func viewWillAppear() {
        if operations == nil {
            operations = OperationFilter.allCases()
        }
        view.setMarker(operations: operations!)
        if let periodTo = periodTo {
            view.setDate(to: format(date: periodTo),
                         date: periodTo)
        }
        if let periodFrom = periodFrom {
            view.setDate(from: format(date: periodFrom),
                         date: periodFrom)
        }
    }
    
    
    func operationTypeDidChange(operation: OperationFilter) {
        if operations == nil {
            operations = []
        }
        
        let remove = operations!.contains(operation)
        
        if remove {
            if operation == .all {
                operations!.removeAll()
            } else {
                operations!.removeAll { (operationFilter) -> Bool in
                    operationFilter == operation || operationFilter == .all
                }
            }
        } else {
            if operation == .all {
                operations = OperationFilter.allCases()
            } else {
                operations?.append(operation)
                if operations?.count == OperationFilter.allCases().count - 1 {
                    operations = OperationFilter.allCases()
                }
            }
        }
        view.setMarker(operations: operations!)
    }
    
}


