//
//  SaleResponse.swift
//  carWash
//
//  Created by Juliett Kuroyan on 19.12.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//


// MARK: - SaleResponse

struct SalesResponse: Codable {
    var current_page: Int
    var data: [SaleResponse]
    var first_page_url: String
    var from: Int?
    var last_page: Int
    var last_page_url: String
    var next_page_url: String?
    var path: String
    var per_page: String
    var prev_page_url: String?
    var to: Int?
    var total: Int
}


// MARK: - SaleResponseData

struct SaleResponse: Codable {
    var id: Int
    var status: String
    var started_at: String?
    var finished_at: String?
    var cashback: Int
    var title: String
    var text: String
    var logo: String
    var washes: [WashResponse]?
}
