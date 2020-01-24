//
//  UserResponse.swift
//  carWash
//
//  Created by Juliett Kuroyan on 05.12.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//


// MARK: - UserResponse

struct UserResponse: Codable {
    var status: String?
    var message: String?
    var data: UserResponseData
    var month_cash_back: [Cashback]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try? container.decode(String.self, forKey: .status)
        self.message = try? container.decode(String.self, forKey: .message)
        self.data = try container.decode(UserResponseData.self, forKey: .data)
        self.month_cash_back = try container.decode([Cashback].self, forKey: .month_cash_back)
    }
    
    private enum CodingKeys : String, CodingKey {
        case status, message, data, month_cash_back
    }

    
}


// MARK: - UserResponseData

struct UserResponseData: Codable {
    var id: Int
    var name: String?
    var phone: String
    var city: String
    var balance: Int?
    var month_spent: Int
    var email: String?
    var email_verified_at: String?
    var last_sms_send_at: String?
    var created_at: String?
    var updated_at: String?
    
//    private enum CodingKeys : String, CodingKey {
//        case id, name, phone, balance, month_balance, email, email_verified_at, last_sms_send_at, created_at, updated_at
//    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try? container.decode(String.self, forKey: .name)
        phone = try container.decode(String.self, forKey: .phone)
        balance = try? container.decode(Int?.self, forKey: .balance)
        city = try container.decode(String.self, forKey: .city)
        if let _ = balance {
            balance! /= 100
        }
        self.month_spent = try container.decode(Int.self, forKey: .month_spent) / 100
        self.email = try? container.decode(String?.self, forKey: .email)
        self.email_verified_at = try? container.decode(String?.self, forKey: .email_verified_at)
        self.last_sms_send_at = try? container.decode(String?.self, forKey: .last_sms_send_at)
        self.created_at = try? container.decode(String?.self, forKey: .created_at)
        self.updated_at = try? container.decode(String?.self, forKey: .updated_at)
    }

}

struct Cashback: Codable {
    var percent: Int
    var value: Int
    
    init(from decoder: Decoder) throws {
          let container = try decoder.container(keyedBy: CodingKeys.self)
          self.percent = try container.decode(Int.self, forKey: .percent)
          self.value = try container.decode(Int.self, forKey: .value) / 100
      }

}
