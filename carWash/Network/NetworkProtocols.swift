//
//  NetworkProtocols.swift
//  LaMenu
//
//  Created by Juliett on 02/08/2019.
//  Copyright © 2019 VooDo. All rights reserved.


import PromiseKit
import Alamofire

// MARK: - Request
protocol NetworkRequestProtocol: class {
    var url: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var headers: HTTPHeaders? { get }
    var succeedCodes: [Int] { get }
    var encoding: ParameterEncoding { get }

    init(_ networkClient: NetworkClientProtocol)
}

// MARK: - Client
protocol NetworkClientProtocol: class {
    func send<T: Codable>(request: NetworkRequestProtocol) -> Promise<T>
}
