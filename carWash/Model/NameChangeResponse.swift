//
//  NameChangeResponse.swift
//  carWash
//
//  Created by Juliett Kuroyan on 23.12.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//


// MARK: - NameChangeResponse

struct NameChangeResponse: Codable {
    
    var status: String?
    var message: String?
    var errors: NameChangeErrors?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try? container.decode(String.self, forKey: .status)
        self.message = try? container.decode(String?.self, forKey: .message)
        self.errors = try? container.decode(NameChangeErrors?.self, forKey: .errors)
    
    }
    
}


struct NameChangeErrors: Codable {
    var name: [String]
}
