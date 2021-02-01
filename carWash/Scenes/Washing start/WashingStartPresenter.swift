//
//  WashingStartPresenter.swift
//  carWash
//
//  Created by Juliett Kuroyan on 06.02.2020.
//  Copyright © 2020 VooDooLab. All rights reserved.
//

import Foundation

class WashingStartPresenter {
    
    // MARK: - Properties
    
    unowned let view: WashingStartViewProtocol
    let router: WashingStartRouterProtocol
    
    
    // MARK: - Lifecycle
    
    init(view: WashingStartViewProtocol,
         router: WashingStartRouterProtocol) {
        self.view = view
        self.router = router
    }
    
    
}

// MARK: - WashingStartPresenterProtocol

extension WashingStartPresenter: WashingStartPresenterProtocol {
  
    func terminalSelected(_ text: String?) {
      guard let text = text, !text.isEmpty else {
        return
      }
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
      router.startWash(code: text, onSuccess: onSuccess, onFailure: onFailure)
    }
  
    func mapViewTapped() {
        router.presentMapView()
    }
    
    func qrViewTapped() {
        router.presentQRView()
    }
    
}
