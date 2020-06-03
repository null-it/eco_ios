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
    var secondsToSend: Int?
    var type: GetAuthCodeResponseStatus = .error
    
    
    private enum CodingKeys : String, CodingKey {
        case status, msg, type, secondsToSend = "seconds_to_send"
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try container.decode(String.self, forKey: .status)
        self.msg = try? container.decode(String?.self, forKey: .msg)
        self.secondsToSend = try? container.decode(Int?.self, forKey: .secondsToSend)
        
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
