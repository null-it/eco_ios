//
//  LoginResponse.swift
//  carWash
//
//  Created by Juliett Kuroyan on 05.12.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//


// MARK: - LoginResponseStatus

enum LoginResponseStatus: String, Codable {
    case ok
    case error
}


// MARK: - LoginResponse

struct LoginResponse: Codable {
    
    var type: LoginResponseStatus = .error
    var status: String
    var msg: String?
    var data: LoginResponseData?
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try container.decode(String.self, forKey: .status)
        self.msg = try? container.decode(String?.self, forKey: .msg)
        self.data = try? container.decode(LoginResponseData?.self, forKey: .data)
        
        switch status {
        case "ok":
            self.type = .ok
        case "error":
            self.type = .error
        default:
            ()
        }
        
    }
    
}


// MARK: - LoginResponseData

struct LoginResponseData: Codable {
    var token_type: String
    var token: String
    var expires_at: String
}
