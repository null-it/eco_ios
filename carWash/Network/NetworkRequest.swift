//
//  NetworkRequest.swift
//  LaMenu
//
//  Created by Juliett on 02/08/2019.
//  Copyright © 2019 VooDo. All rights reserved.
//


import Alamofire
import PromiseKit
import SwiftKeychainWrapper

class Request
{
    static let contentType = "application/json"
    static let accept = "application/json"
    static var authorization: String {
        let token = KeychainWrapper.standard.string(forKey: "userToken")
        return token ?? ""
    }
    
    // MARK: - AuthCode
    class AuthCode {
        
        class Get: NetworkRequestProtocol {
            
            var url = "get-auth-code/"
            var method: HTTPMethod = .get
            var parameters: Parameters?
            var headers: HTTPHeaders?
            var succeedCodes = [200, 404, 409] // remoce 401
            var encoding: ParameterEncoding = URLEncoding(destination: .methodDependent, arrayEncoding: .noBrackets, boolEncoding: .numeric)
            
            private let networkClient: NetworkClientProtocol
            
            required init(_ networkClient: NetworkClientProtocol) {
                self.networkClient = networkClient
                self.headers = HTTPHeaders()
                self.headers?["Content-Type"] = Request.contentType
                self.headers?["Accept"] = Request.accept
            }
            
            convenience init(phone: String, networkClient: NetworkClientProtocol = NetworkClient.shared) {
                self.init(networkClient)
                self.parameters = Parameters()
                self.parameters?["phone"] = phone
            }
            
            func send() -> Promise<GetAuthCodeResponse> {
                return self.networkClient.send(request: self)
            }
            
        }
        
    }
    
    
    // MARK: - Login
    class Login {
        
        class Post: NetworkRequestProtocol {
            
            var url = "login"
            var method: HTTPMethod = .post
            var parameters: Parameters?
            var headers: HTTPHeaders?
            var succeedCodes = [200, 401]
            var encoding: ParameterEncoding = JSONEncoding.default
            
            private let networkClient: NetworkClientProtocol
            
            required init(_ networkClient: NetworkClientProtocol) {
                self.networkClient = networkClient
                self.headers = HTTPHeaders()
                self.headers?["Content-Type"] = Request.contentType
                self.headers?["Accept"] = Request.accept
            }
            
            convenience init(phone: String, code: String, networkClient: NetworkClientProtocol = NetworkClient.shared) {
                self.init(networkClient)
                self.parameters = Parameters()
                self.parameters?["phone"] = phone
                self.parameters?["code"] = code
            }
            
            func send() -> Promise<LoginResponse> {
                return self.networkClient.send(request: self)
            }
            
        }
        
    }
    
    // MARK: - User
    class User {
        
        class Get: NetworkRequestProtocol {
            
            var url = "user"
            var method: HTTPMethod = .get
            var parameters: Parameters?
            var headers: HTTPHeaders?
            var succeedCodes = [200, 403]
            var encoding: ParameterEncoding = URLEncoding(destination: .methodDependent, arrayEncoding: .noBrackets, boolEncoding: .numeric)
            
            private let networkClient: NetworkClientProtocol
            
            required init(_ networkClient: NetworkClientProtocol = NetworkClient.shared) {
                self.networkClient = networkClient
                self.headers = HTTPHeaders()
                //                self.headers?["Content-Type"] = Request.contentType
                self.headers?["Authorization"] = Request.authorization
                self.headers?["Accept"] = Request.accept
            }
            
            
            func send() -> Promise<UserResponse> {
                return self.networkClient.send(request: self)
            }
            
        }
        
        class Post: NetworkRequestProtocol {
            
            var url = "user/set-name"
            var method: HTTPMethod = .post
            var parameters: Parameters?
            var headers: HTTPHeaders?
            var succeedCodes = [200, 422]
            var encoding: ParameterEncoding = JSONEncoding.default
            
            private let networkClient: NetworkClientProtocol
            
            required init(_ networkClient: NetworkClientProtocol) {
                self.networkClient = networkClient
                self.headers = HTTPHeaders()
                self.headers?["Content-Type"] = Request.contentType
                self.headers?["Accept"] = Request.accept
                self.headers?["Authorization"] = Request.authorization
            }
            
            convenience init(name: String, networkClient: NetworkClientProtocol = NetworkClient.shared) {
                self.init(networkClient)
                self.parameters = Parameters()
                self.parameters?["name"] = name
            }
            
            func send() -> Promise<NameChangeResponse> {
                return self.networkClient.send(request: self)
            }
            
        }
        
        class Logout {
            
            class Get: NetworkRequestProtocol {
                
                var url = "user/logout"
                var method: HTTPMethod = .get
                var parameters: Parameters?
                var headers: HTTPHeaders?
                var succeedCodes = [200]
                var encoding: ParameterEncoding = URLEncoding(destination: .methodDependent, arrayEncoding: .noBrackets, boolEncoding: .numeric)
                
                private let networkClient: NetworkClientProtocol
                
                required init(_ networkClient: NetworkClientProtocol = NetworkClient.shared) {
                    self.networkClient = networkClient
                    self.headers = HTTPHeaders()
                    self.headers?["Authorization"] = Request.authorization
                    self.headers?["Accept"] = Request.accept
                    self.headers?["Content-Type"] = Request.contentType
                }
                
                
                func send() -> Promise<UserLogoutResponse> {
                    return self.networkClient.send(request: self)
                }
                
            }
            
        }
        
        
        class Operations {
            
            class Get: NetworkRequestProtocol {
                
                var url = "user/operations"
                var method: HTTPMethod = .get
                var parameters: Parameters?
                var headers: HTTPHeaders?
                var succeedCodes = [200]
                var encoding: ParameterEncoding = URLEncoding(destination: .methodDependent, arrayEncoding: .noBrackets, boolEncoding: .numeric)
                
                private let networkClient: NetworkClientProtocol
                
                required init(_ networkClient: NetworkClientProtocol = NetworkClient.shared) {
                    self.networkClient = networkClient
                    self.headers = HTTPHeaders()
                    self.headers?["Authorization"] = Request.authorization
                    self.headers?["Accept"] = Request.accept
                    self.headers?["Content-Type"] = Request.contentType
                }
                
                convenience init( page: Int, qty: Int?, networkClient: NetworkClientProtocol = NetworkClient.shared) {
                    self.init(networkClient)
                    self.parameters = Parameters()
                    self.parameters?["page"] = page
                    if let qty = qty {
                        self.parameters?["qty"] = qty
                    }
                }
                
                func send() -> Promise<UserOperationsResponse> {
                    return self.networkClient.send(request: self)
                }
                
            }
            
        }
        
        
        class SetFirebaseToken {
            
            class Post: NetworkRequestProtocol {
                
                var url = "user/set-firebase-token"
                var method: HTTPMethod = .post
                var parameters: Parameters?
                var headers: HTTPHeaders?
                var succeedCodes = [200]
                var encoding: ParameterEncoding = JSONEncoding.default
                
                private let networkClient: NetworkClientProtocol
                
                required init(_ networkClient: NetworkClientProtocol) {
                    self.networkClient = networkClient
                    self.headers = HTTPHeaders()
                    self.headers?["Content-Type"] = Request.contentType
                    self.headers?["Accept"] = Request.accept
                    self.headers?["Authorization"] = Request.authorization
                }
                
                convenience init(token: String, networkClient: NetworkClientProtocol = NetworkClient.shared) {
                    self.init(networkClient)
                    self.parameters = Parameters()
                    self.parameters?["token"] = token
                }
                
                func send() -> Promise<SetFirebaseTokenResponse> {
                    return self.networkClient.send(request: self)
                }
                
            }
            
        }
        
    }
    
    
    class Cities {
        
        class Get: NetworkRequestProtocol {
            
            var url = "cities"
            var method: HTTPMethod = .get
            var parameters: Parameters?
            var headers: HTTPHeaders?
            var succeedCodes = [200]
            var encoding: ParameterEncoding = URLEncoding(destination: .methodDependent, arrayEncoding: .noBrackets, boolEncoding: .numeric)
            
            private let networkClient: NetworkClientProtocol
            
            required init(_ networkClient: NetworkClientProtocol = NetworkClient.shared) {
                self.networkClient = networkClient
                self.headers = HTTPHeaders()
                self.headers?["Authorization"] = Request.authorization
                self.headers?["Accept"] = Request.accept
                self.headers?["Content-Type"] = Request.contentType
            }
            
            
            func send() -> Promise<CitiesResponse> {
                return self.networkClient.send(request: self)
            }
        }
        
    }
    
    
    class Wash {
        
        class Get: NetworkRequestProtocol {
            
            var url = "wash"
            var method: HTTPMethod = .get
            var parameters: Parameters?
            var headers: HTTPHeaders?
            var succeedCodes = [200]
            var encoding: ParameterEncoding = URLEncoding(destination: .methodDependent, arrayEncoding: .noBrackets, boolEncoding: .numeric)
            
            private let networkClient: NetworkClientProtocol
            
            required init(_ networkClient: NetworkClientProtocol = NetworkClient.shared) {
                self.networkClient = networkClient
                self.headers = HTTPHeaders()
                self.headers?["Authorization"] = Request.authorization
                self.headers?["Accept"] = Request.accept
                self.headers?["Content-Type"] = Request.contentType
            }
            
            
            convenience init(city: String?, networkClient: NetworkClientProtocol = NetworkClient.shared) {
                self.init(networkClient)
                if let city = city {
                    self.parameters = Parameters()
                    self.parameters?["city"] = city
                }
            }
            
            
            convenience init(id: Int, networkClient: NetworkClientProtocol = NetworkClient.shared) {
                self.init(networkClient)
                url += "/\(id)"
            }
            
            
            func send() -> Promise<WashesResponse> {
                return self.networkClient.send(request: self)
            }
            
            
            func send() -> Promise<WashResponse> {
                return self.networkClient.send(request: self)
            }
        }
        
    }
    
    
    class Sale {
        
        class Get: NetworkRequestProtocol {
            
            var url = "stock"
            var method: HTTPMethod = .get
            var parameters: Parameters?
            var headers: HTTPHeaders?
            var succeedCodes = [200]
            var encoding: ParameterEncoding = URLEncoding(destination: .methodDependent, arrayEncoding: .noBrackets, boolEncoding: .numeric)
            
            private let networkClient: NetworkClientProtocol
            
            required init(_ networkClient: NetworkClientProtocol = NetworkClient.shared) {
                self.networkClient = networkClient
                self.headers = HTTPHeaders()
                self.headers?["Authorization"] = Request.authorization
                self.headers?["Accept"] = Request.accept
                self.headers?["Content-Type"] = Request.contentType
            }
            
            convenience init(city: String?, networkClient: NetworkClientProtocol = NetworkClient.shared) {
                self.init(networkClient)
                if let city = city {
                    self.parameters = Parameters()
                    self.parameters?["city"] = city
                }
            }
            
            func send() -> Promise<SalesResponse> {
                return self.networkClient.send(request: self)
            }
        }
        
    }
    
    
}
