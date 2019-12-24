//
//  GetAuthCodeResponse.swift
//  carWash
//
//  Created by Juliett Kuroyan on 05.12.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//


// MARK: - GetAuthCodeResponseStatus

enum GetAuthCodeResponseStatus: String, Codable {
    case ok
    case error
    case timeout
}


// MARK: - GetAuthCodeResponse

struct GetAuthCodeResponse: Codable {
    var status: String
    var msg: String?
    var seconds_to_send: Int?
    var type: GetAuthCodeResponseStatus = .error
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try container.decode(String.self, forKey: .status)
        self.msg = try? container.decode(String?.self, forKey: .msg)
        self.seconds_to_send = try? container.decode(Int?.self, forKey: .seconds_to_send)
        
        switch status {
        case "ok":
            self.type = .ok
        case "error":
            self.type = self.msg == "Timeout"
                ? .timeout
                : .error
        default:
            ()
        }
    }
}
