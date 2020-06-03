//
//  UserOperationsResponse.swift
//  carWash
//
//  Created by Juliett Kuroyan on 09.12.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//
import Foundation

// MARK: - UserOperationsResponse

struct UserOperationsResponse: Codable {
    
    var currentPage: Int
    var data: [UserOperationResponse]
    var firstPageUrl: String
    var from: Int?
    var lastPage: Int
    var lastPageUrl: String
    var nextPageUrl: String?
    var path: String
    var perPage: String
    var prevPageUrl: String?
    var to: Int?
    var total: Int
    
    private enum CodingKeys : String, CodingKey {
        case currentPage = "current_page",
        data,
        firstPageUrl = "first_page_url",
        from,
        lastPage = "last_page",
        lastPageUrl = "last_page_url",
        nextPageUrl = "next_page_url",
        path,
        perPage = "per_page",
        prevPageUrl = "prev_page_url",
        to,
        total
    }
    

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.currentPage = try container.decode(Int.self, forKey: .currentPage)
        self.data = try container.decode([UserOperationResponse].self, forKey: .data)
        self.firstPageUrl = try container.decode(String.self, forKey: .firstPageUrl)
        self.from = try? container.decode(Int?.self, forKey: .from)
        self.lastPage = try container.decode(Int.self, forKey: .lastPage)
        self.lastPageUrl = try container.decode(String.self, forKey: .lastPageUrl)
        self.nextPageUrl = try? container.decode(String?.self, forKey: .nextPageUrl)
        self.path = try container.decode(String.self, forKey: .path)
        self.perPage = try container.decode(String.self, forKey: .perPage)
        self.prevPageUrl = try? container.decode(String?.self, forKey: .prevPageUrl)
        self.to = try? container.decode(Int?.self, forKey: .to)
        self.total = try container.decode(Int.self, forKey: .total)
    }
    
}


// MARK: - UserOperationResponse

struct UserOperationResponse: Codable {
   
    var id: Int
    var user_id: Int
    var type: String
    var value: Int
    var wash_id: Int?
    var terminal_id: Int?
    var created_at: String
    var wash: Wash?
    var terminal: Terminal?
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.user_id = try container.decode(Int.self, forKey: .user_id)
        self.type = try container.decode(String.self, forKey: .type)
        self.value = try container.decode(Int.self, forKey: .value) / 100
        self.wash_id = try container.decode(Int?.self, forKey: .wash_id)
        self.terminal_id = try? container.decode(Int?.self, forKey: .terminal_id)
        let createdAtString = try container.decode(String.self, forKey: .created_at)
        let dateFormatter = DateFormatter()
        created_at = dateFormatter.string(dateString: createdAtString,
                                          fromFormat: Constants.fromFormat,
                                          toHourFormat: Constants.toFormatTime)
        self.wash = try container.decode(Wash?.self, forKey: .wash)
        self.terminal = try? container.decode(Terminal?.self, forKey: .terminal)
    }
    
}


// MARK: - Wash

struct Wash: Codable {
    
    var id: Int
    var city: String
    var address: String
    var coordinates: [Double]
    var cashback: Int
    var seats: Int

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.city = try container.decode(String.self, forKey: .city)
        self.address = try container.decode(String.self, forKey: .address)
        self.coordinates = try container.decode([Double].self, forKey: .coordinates)
        self.cashback = try container.decode(Int.self, forKey: .cashback)
        self.seats = try container.decode(Int.self, forKey: .seats)
    }
    
}


// MARK: - Terminal

struct Terminal: Codable {
    
    var id: Int
    var name: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
    }
    
}
