//
//  WashResponse.swift
//  carWash
//
//  Created by Juliett Kuroyan on 09.12.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

struct WashResponse: Codable {
    var id: Int
    var city: String
    var address: String
    var coordinates: [Double]
    var cashback: Int
    var seats: Int
    var stocks: [StockResponse]?
    var pivot: Pivot?
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
}

struct Pivot: Codable {
    var wash_id: Int
    var stock_id: Int
}
