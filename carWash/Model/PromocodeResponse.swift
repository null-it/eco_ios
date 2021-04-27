//
//  PromocodeResponse.swift
//  carWash
//
//  Created by Захар  Сегал on 27.04.2021.
//  Copyright © 2021 VooDooLab. All rights reserved.
//

import Foundation

enum PromocodeStatus: String, Codable {
    case ok
    case error
}

struct PromocodeResponse: Codable {
    let status: PromocodeStatus
    let message: String
    
    private enum CodingKeys : String, CodingKey {
        case status, message
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let status = try container.decode(String.self, forKey: .status)
        if status == "ok" {
            self.status = .ok
        } else {
            self.status = .error
        }
        self.message = try container.decode(String.self, forKey: .message)
    }
}
