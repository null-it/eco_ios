//
//  QRInteractor.swift
//  carWash
//
//  Created by Juliett Kuroyan on 03.02.2020.
//  Copyright © 2020 VooDooLab. All rights reserved.
//

import Foundation

class QRInteractor {
    
    unowned var presenter: QRPresenterProtocol
    
    init(presenter: QRPresenterProtocol) {
        self.presenter = presenter
    }
    
}

// MARK: - QRInteractorProtocol

extension QRInteractor: QRInteractorProtocol {
    
    func startWash(code: String,
                   onSuccess: @escaping (WashStartResponse) -> (),
                   onFailure: @escaping () -> ()?) {
        let request = Request.Wash.Start.Post(code: code)
        request.send().done { response in
            onSuccess(response)
        }.catch { error in
            print(error)
            onFailure()
        }
    }
    
}
