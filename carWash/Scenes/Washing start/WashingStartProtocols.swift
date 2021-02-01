//
//  WashingStartProtocols.swift
//  carWash
//
//  Created by Juliett Kuroyan on 06.02.2020.
//  Copyright © 2020 VooDooLab. All rights reserved.
//

import Foundation

// MARK: - View
protocol WashingStartViewProtocol: class {
    func setSucceeded(message: String)
    func setError(message: String)
}

// MARK: - Presenter
protocol WashingStartPresenterProtocol: class {
    func mapViewTapped()
    func qrViewTapped()
    func terminalSelected(_ text: String?)
}

// MARK: - Router
protocol WashingStartRouterProtocol {
    func presentQRView()
    func presentMapView()
    func startWash(code: String,
                 onSuccess: @escaping (WashStartResponse) -> (),
                 onFailure: @escaping () -> ()?)
}

// MARK: - Configurator
protocol WashingStartConfiguratorProtocol {
    
}
