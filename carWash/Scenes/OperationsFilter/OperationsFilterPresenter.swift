//
//  OperationsFilterPresenter.swift
//  carWash
//
//  Created by Juliett Kuroyan on 15.01.2020.
//  Copyright © 2020 VooDooLab. All rights reserved.
//

import Foundation


enum OperationFilter: Int {
    case waste = 0, replenishOnline, replenishOffline, cashback, all
    
    func description() -> String {
        switch self {
        case .waste:
            return "waste"
        case .replenishOnline:
            return "replenish_online"
        case .replenishOffline:
            return "replenish_offline"
        case .cashback:
            return "cashback"
        case .all:
            return "all"
        }
    }
    
    static func allCases() -> [OperationFilter] {
        return [.waste, .replenishOnline, replenishOffline, .cashback, .all]
    }
}


class OperationsFilterPresenter {
    
    // MARK: - Properties
    
    unowned let view: OperationsFilterViewProtocol
    var interactor: OperationsFilterInteractorProtocol!
    let router: OperationsFilterRouterProtocol
      
//    var operations: [OperationFilter]?
    var operation: OperationFilter = .all
    var periodFrom: Date?
    var periodTo: Date?
    var completion: (([OperationFilter]?, Date?, Date?) -> ())?
    
    init(view: OperationsFilterViewProtocol,
         router: OperationsFilterRouterProtocol) {
        self.view = view
        self.router = router
    }
    
    
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
        operation = .all
        view.setDate(from: "",
                     date: nil)
        view.setDate(to: "",
                     date: nil)
        view.setMarker(operations: [operation])

    }
    
    
    func filterButtonPressed() {
        router.popView()
        completion?([operation], periodFrom, periodTo)
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
    
    
    func viewDidLoad() {
//        if operations == nil {
//            operations = OperationFilter.allCases()
//        }
        view.setMarker(operations: [operation])
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
//        if operations == nil {
//            operations = []
//        }
//
//        let remove = operations!.contains(operation)
//
//        if remove {
//            if operation == .all {
//                operations!.removeAll()
//            } else {
//                operations!.removeAll { (operationFilter) -> Bool in
//                    operationFilter == operation || operationFilter == .all
//                }
//            }
//        } else {
//            if operation == .all {
//                operations = OperationFilter.allCases()
//            } else {
//                operations?.append(operation)
//                if operations?.count == OperationFilter.allCases().count - 1 {
//                    operations = OperationFilter.allCases()
//                }
//            }
//        }
        self.operation = operation
        view.setMarker(operations: [operation])
    }
    
    
    
}


