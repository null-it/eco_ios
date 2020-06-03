//
//  ReviewResponse.swift
//  carWash
//
//  Created by Juliett Kuroyan on 09.01.2020.
//  Copyright © 2020 VooDooLab. All rights reserved.
//

// MARK: - ReviewResponse

struct ReviewResponse: Codable {
    
    var status: String
    var msg: String?
    var data: ReviewData?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try container.decode(String.self, forKey: .status)
        self.msg = try? container.decode(String?.self, forKey: .msg)
        self.data = try? container.decode(ReviewData?.self, forKey: .data)
    }
    
}


// MARK: - ReviewData

struct ReviewData: Codable {
    
    var stars: Double
    var text: String
    var user_id: Int
    var operation_id: Int
    var created_at: String
    var id: Int
    
}
