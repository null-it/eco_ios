//
//  WashResponse.swift
//  carWash
//
//  Created by Juliett Kuroyan on 09.12.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//
import Foundation

struct WashResponse: Codable {
    
    var id: Int
    var city: String
    var address: String
    var coordinates: [Double]
    var cashback: Int
    var seats: Int
    var stocks: [StockResponse]?
    var pivot: Pivot?
    var happyHours: HappyHours?
    var systemId: String

    private enum CodingKeys : String, CodingKey {
        case id, city, address, coordinates, cashback, seats, stocks, pivot, happyHours = "happy-hours", systemId = "system_id"
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        city = try container.decode(String.self, forKey: .city)
        address = try container.decode(String.self, forKey: .address)
        coordinates = try container.decode([Double].self, forKey: .coordinates)
        cashback = try container.decode(Int.self, forKey: .cashback)
        seats = try container.decode(Int.self, forKey: .seats)
        stocks = try? container.decode([StockResponse]?.self, forKey: .stocks)
        pivot = try? container.decode(Pivot?.self, forKey: .pivot)
        happyHours = try? container.decode(HappyHours?.self, forKey: .happyHours)
        systemId = try container.decode(String.self, forKey: .systemId)
    }
    
}


struct StockResponse: Codable {
    
    var id: Int
    var status: String
    var started_at: String
    var finished_at: String
    var cashback: Int
    var title: String
    var text: String
    var pivot: Pivot
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.status = try container.decode(String.self, forKey: .status)
        
        let dateFormatter = DateFormatter()
        
        if let startedString = try? container.decode(String?.self, forKey: .started_at) {
            started_at = dateFormatter.string(dateString: startedString,
                                              fromFormat: Constants.fromFormat,
                                              toHourFormat: nil)
        } else {
            started_at = ""
        }
        
        if let finishedString = try? container.decode(String?.self, forKey: .finished_at) {
            finished_at = dateFormatter.string(dateString: finishedString,
                                               fromFormat: Constants.fromFormat,
                                               toHourFormat: nil)
        } else {
            finished_at = ""
        }
        
        self.cashback = try container.decode(Int.self, forKey: .cashback)
        self.title = try container.decode(String.self, forKey: .title)
        self.text = try container.decode(String.self, forKey: .text)
        self.pivot = try container.decode(Pivot.self, forKey: .pivot)
    }
    
}

struct Pivot: Codable {
    var wash_id: Int
    var stock_id: Int
}


struct HappyHours: Codable {
    
    var active: Bool
    var isEnabled: Bool
    var start: String
    var end: String

    private enum CodingKeys : String, CodingKey {
        case active, start, end, isEnabled = "switch"
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        active = try container.decode(Bool.self, forKey: .active)
        start = try container.decode(String.self, forKey: .start)
        end = try container.decode(String.self, forKey: .end)
        isEnabled = try container.decode(Bool.self, forKey: .isEnabled)
    }
    
}
