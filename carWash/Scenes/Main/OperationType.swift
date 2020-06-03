//
//  OperationType.swift
//  carWash
//
//  Created by Juliett Kuroyan on 14.01.2020.
//  Copyright © 2020 VooDooLab. All rights reserved.
//

enum OperationType: String {
    case waste
    case replenish_online
    case replenish_offline
    case cashback
    
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
