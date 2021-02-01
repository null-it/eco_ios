//
//  QRProtocols.swift
//  carWash
//
//  Created by Juliett Kuroyan on 03.02.2020.
//  Copyright © 2020 VooDooLab. All rights reserved.
//

import Foundation


// MARK: - View
protocol QRViewProtocol: class {
    func setError(message: String)
    func setSucceeded(message: String)
}


// MARK: - Presenter
protocol QRPresenterProtocol: class {
    func popView()
    func found(code: String) 
}


// MARK: - Router
protocol QRRouterProtocol {
    func popView()
}


// MARK: - Interactor
protocol QRInteractorProtocol: class {
    func startWash(code: String,
                   onSuccess: @escaping (WashStartResponse) -> (),
                   onFailure: @escaping () -> ()?) 
}


// MARK: - Configurator
protocol QRConfiguratorProtocol {
    
}
