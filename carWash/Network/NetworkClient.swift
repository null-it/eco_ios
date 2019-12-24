//
//  NetworkClient.swift
//  LaMenu
//
//  Created by Juliett on 02/08/2019.
//  Copyright © 2019 VooDo. All rights reserved.
//

import PromiseKit
import Alamofire

class NetworkClient {
    let serverURL: String

    static let shared : NetworkClient =  {
        let instance = NetworkClient(serverURL: "http://eco.voodoolab.io/api/")
        return instance
    }()

    init(serverURL: String)
    {
        self.serverURL = serverURL
    }
}

// MARK: - NetworkClientProtocol
extension NetworkClient: NetworkClientProtocol {
    func send<T: Codable>(request: NetworkRequestProtocol) -> Promise<T> {
        return firstly {
            Alamofire
                .request(
                    serverURL + request.url,
                    method: request.method,
                    parameters: request.parameters,
                    encoding: request.encoding,
                    headers: request.headers
            ).debugLog()
                .validate(statusCode: request.succeedCodes)
                .responseData()
            }.map { args in
                
                let data = args.data
                let utf8Text = String(data: data, encoding: .utf8)
                print("Data: \(utf8Text)")
                
                return try JSONDecoder().decode(T.self, from: args.data)
        }
    }
}


extension DataRequest {
    
   public func debugLog() -> Self {
      #if DEBUG
         debugPrint(self)
      #endif
      return self
   }
    
}
