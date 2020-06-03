//
//  QRPresenter.swift
//  carWash
//
//  Created by Juliett Kuroyan on 03.02.2020.
//  Copyright © 2020 VooDooLab. All rights reserved.
//

import Foundation

class QRPresenter {
    
    // MARK: - Properties
    
    unowned let view: QRViewProtocol
    var interactor: QRInteractorProtocol!
    let router: QRRouterProtocol
    
    
    // MARK: - Lifecycle
    
    init(view: QRViewProtocol,
         router: QRRouterProtocol) {
        self.view = view
        self.router = router
    }
    
}


// MARK: - QRPresenterProtocol

extension QRPresenter: QRPresenterProtocol {
    
    func popView() {
        router.popView()
    }
    
    func found(code: String) {
        
        let onSuccess: (WashStartResponse) -> () = { [weak self] (wash) in
            switch wash.status {
            case "ok":
                self?.view.setSucceeded(message: QRConstants.defaultSucceededMessage)
            default:
                let message = wash.msg ?? QRConstants.defaultErrorMessage
                self?.view.setError(message: message)
            }
        }
        
        let onFailure: () -> ()? = { [weak self] in
            self?.view.setError(message: QRConstants.defaultErrorMessage)
        }
        
        interactor.startWash(code: code,
                             onSuccess: onSuccess,
                             onFailure: onFailure)
    }
    
}
