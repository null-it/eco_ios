//
//  LoginInteractor.swift
//  carWash
//
//  Created by Juliett Kuroyan on 26.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//
import Firebase

class LoginInteractor {
    
    unowned var presenter: LoginPresenterProtocol
    
    init(presenter: LoginPresenterProtocol) {
        self.presenter = presenter
    }
    
    
}

// MARK: - LoginInteractorProtocol

extension LoginInteractor: LoginInteractorProtocol {
   
    func checkPassword(dto: CheckPasswordDTO, onSuccess: @escaping (LoginResponse) -> (), onFailure: @escaping () -> ()?) {
        let request = Request.Login.Post(phone: dto.phone,
                                         code: dto.code)
        request.send().done { response in
            onSuccess(response)
        }.catch { error in
            print(error)
            onFailure()
        }
    }
    
    
    func sendPassword(phoneNumber: String,
                      onSuccess: @escaping (GetAuthCodeResponse) -> (),
                      onFailure: @escaping () -> ()?) {
        let request = Request.AuthCode.Get(phone: phoneNumber)
        request.send().done { response in
            onSuccess(response)
        }.catch { error in
            print(error)
            onFailure()
        }
    }
    
}

