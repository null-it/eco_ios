//
//  PaymentProtocols.swift
//  carWash
//
//  Created by Juliett Kuroyan on 27.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import Foundation

// MARK: - View
protocol PaymentViewProtocol: class {
    func updateFor(info: [PaymentTypeInfo])
    func setSum(text: String)
    func setTableView(enabled: Bool) 
}

// MARK: - Presenter
protocol PaymentPresenterProtocol: class {
    func popView()
    func viewDidLoad()
    func sumDidBeginEditing()
    func sumDidEndEditing()
    func shouldChangeSumCharacters(in range: NSRange,
                                   replacementString string: String) -> Bool
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
