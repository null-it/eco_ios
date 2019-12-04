//
//  MainProtocol.swift
//  carWash
//
//  Created by Juliett Kuroyan on 18.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//


// MARK: - View
protocol MainViewProtocol: class {
   func updateFor(info: [CashbackTypeInfo])
}

// MARK: - Presenter
protocol MainPresenterProtocol: class {
    func presentPaymentView()
    func viewDidLoad()
    func logout()
}

// MARK: - Router
protocol MainRouterProtocol {
    func presentPaymentView()
    func popToAuthorization()
}

// MARK: - Interactor
protocol MainInteractorProtocol: class {
    
}

// MARK: - Configurator
protocol MainConfiguratorProtocol {
    
}
