//
//  SaleResponse.swift
//  carWash
//
//  Created by Juliett Kuroyan on 19.12.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import Foundation

// MARK: - SaleResponse

struct SalesResponse: Codable {
    
    var currentPage: Int?
    var data: [SaleResponse]
    var firstPageUrl: String?
    var from: Int?
    var lastPage: Int?
    var lastPageUrl: String?
    var nextPageUrl: String?
    var path: String?
    var perPage: String?
    var prevPageUrl: String?
    var to: Int?
    var total: Int
    
    
    private enum CodingKeys : String, CodingKey {
        case currentPage,
        data,
        firstPageUrl,
        from,
        lastPage,
        lastPageUrl,
        nextPageUrl,
        path,
        perPage,
        prevPageUrl,
        to,
        total
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        currentPage = try? container.decode(Int?.self, forKey: .currentPage)
        data = try container.decode([SaleResponse].self, forKey: .data)
        firstPageUrl = try? container.decode(String?.self, forKey: .firstPageUrl)
        from = try? container.decode(Int?.self, forKey: .from)
        lastPage = try? container.decode(Int?.self, forKey: .lastPage)
        lastPageUrl = try? container.decode(String?.self, forKey: .lastPageUrl)
        nextPageUrl = try? container.decode(String?.self, forKey: .nextPageUrl)
        path = try? container.decode(String?.self, forKey: .path)
        perPage = try? container.decode(String?.self, forKey: .perPage)
        prevPageUrl = try? container.decode(String?.self, forKey: .prevPageUrl)
        to = try? container.decode(Int?.self, forKey: .to)
        total = try container.decode(Int.self, forKey: .total)
    }
    
}


// MARK: - SaleResponseData

struct SaleResponse: Codable {
    
    var id: Int
    var status: String
    var startedAt: String?
    var finishedAt: String?
    var cashback: Int
    var title: String
    var text: String
    var logo: String
    var washes: [WashResponse]?
    
    private enum CodingKeys : String, CodingKey {
        case id,
        status,
        startedAt = "started_at",
        finishedAt = "finished_at",
        cashback,
        title,
        text,
        logo,
        washes
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.status = try container.decode(String.self, forKey: .status)
        
        let dateFormatter = DateFormatter()
        
        if let startedString = try? container.decode(String?.self, forKey: .startedAt) {
            startedAt = dateFormatter.string(dateString: startedString,
                                              fromFormat: Constants.fromFormat,
                                              toHourFormat: nil)
        }
        
        if let finishedString = try? container.decode(String?.self, forKey: .finishedAt) {
            finishedAt = dateFormatter.string(dateString: finishedString,
                                               fromFormat: Constants.fromFormat,
                                               toHourFormat: nil)
        }
        
        self.cashback = try container.decode(Int.self, forKey: .cashback)
        self.title = try container.decode(String.self, forKey: .title)
        self.text = try container.decode(String.self, forKey: .text)
        self.logo = try container.decode(String.self, forKey: .logo)
        self.washes = try? container.decode([WashResponse]?.self, forKey: .washes)
    }
    
}
