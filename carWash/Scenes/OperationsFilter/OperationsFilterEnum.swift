//
//  OperationsFilter.swift
//  carWash
//
//  Created by Juliett Kuroyan on 14.02.2020.
//  Copyright © 2020 VooDooLab. All rights reserved.
//


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
