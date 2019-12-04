//
//  PaymentProtocols.swift
//  carWash
//
//  Created by Juliett Kuroyan on 27.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//


// MARK: - View
protocol PaymentViewProtocol: class {
    func updateFor(info: [PaymentTypeInfo])
}

// MARK: - Presenter
protocol PaymentPresenterProtocol: class {
    func popView()
    func viewDidLoad()
}

// MARK: - Router
protocol PaymentRouterProtocol {
    func popView()
}

// MARK: - Interactor
protocol PaymentInteractorProtocol: class {
    
}

// MARK: - Configurator
protocol PaymentConfiguratorProtocol {
    
}
