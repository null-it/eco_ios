//
//  UserOperationsResponse.swift
//  carWash
//
//  Created by Juliett Kuroyan on 09.12.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//


// MARK: - UserOperationsResponse

struct UserOperationsResponse: Codable {
    var current_page: Int
    var data: [UserOperationResponse]
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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.current_page = try container.decode(Int.self, forKey: .current_page)
        self.data = try container.decode([UserOperationResponse].self, forKey: .data)
        self.first_page_url = try container.decode(String.self, forKey: .first_page_url)
        self.from = try? container.decode(Int?.self, forKey: .from)
        self.last_page = try container.decode(Int.self, forKey: .last_page)
        self.last_page_url = try container.decode(String.self, forKey: .last_page_url)
        self.next_page_url = try? container.decode(String?.self, forKey: .next_page_url)
        self.path = try container.decode(String.self, forKey: .path)
        self.per_page = try container.decode(String.self, forKey: .per_page)
        self.prev_page_url = try? container.decode(String?.self, forKey: .prev_page_url)
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
        self.created_at = try container.decode(String.self, forKey: .created_at)
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
