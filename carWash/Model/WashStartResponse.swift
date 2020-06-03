//
//  WashStartREsponse.swift
//  carWash
//
//  Created by Juliett Kuroyan on 25.02.2020.
//  Copyright © 2020 VooDooLab. All rights reserved.
//


struct WashStartResponse: Codable {
    var status: String
    var msg: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try container.decode(String.self, forKey: .status)
        self.msg = try? container.decode(String?.self, forKey: .msg)
    }
}
