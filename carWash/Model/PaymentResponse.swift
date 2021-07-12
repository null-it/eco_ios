//
//  PaymentResponse.swift
//  carWash
//
//  Created by Захар  Сегал on 12.07.2021.
//  Copyright © 2021 VooDooLab. All rights reserved.
//

import Foundation

struct PaymentResponse: Codable {
    let status: String
    let data: PaymentResponseData
    
    private enum CodingKeys : String, CodingKey {
        case status, data
    }
}

struct PaymentResponseData: Codable {
    let url: String?
    
    private enum CodingKeys: String, CodingKey {
        case url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let url = try container.decode(String.self, forKey: .url)
        if url.isEmpty {
            self.url = nil
        } else {
            self.url = url
        }
    }
}
