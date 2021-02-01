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
    var monthCashBack: [Cashback]

    private enum CodingKeys : String, CodingKey {
        case status, message, data, monthCashBack = "month_cash_back"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try? container.decode(String.self, forKey: .status)
        self.message = try? container.decode(String.self, forKey: .message)
        self.data = try container.decode(UserResponseData.self, forKey: .data)
        self.monthCashBack = try container.decode([Cashback].self, forKey: .monthCashBack)
    }
    
}


// MARK: - UserResponseData

struct UserResponseData: Codable {
    var id: Int
    var name: String?
    var phone: String
    var city: String
    var balance: Int?
    var monthSpent: Int
    var email: String?
    var emailVerifiedAt: String?
    var lastSmsSendAt: String?
    var createdAt: String?
    var updatedAt: String?
    
    private enum CodingKeys : String, CodingKey {
        case id,
        name,
        phone,
        city,
        balance,
        email, emailVerifiedAt = "email_verified_at",
        lastSmsSendAt = "last_sms_send_at",
        createdAt = "created_at",
        updatedAt = "updated_at",
        monthSpent = "month_spent"
    }
    
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
        self.monthSpent = try container.decode(Int.self, forKey: .monthSpent) / 100
        self.email = try? container.decode(String?.self, forKey: .email)
        self.emailVerifiedAt = try? container.decode(String?.self, forKey: .emailVerifiedAt)
        self.lastSmsSendAt = try? container.decode(String?.self, forKey: .lastSmsSendAt)
        self.createdAt = try? container.decode(String?.self, forKey: .createdAt)
        self.updatedAt = try? container.decode(String?.self, forKey: .updatedAt)
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
