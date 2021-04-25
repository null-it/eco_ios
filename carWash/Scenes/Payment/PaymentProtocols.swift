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
    func needMoreMoney(_ value: Bool)
    func emailIsCorrect(_ value: Bool)
}

// MARK: - Presenter
protocol PaymentPresenterProtocol: class {
    var minDeposit: Int { get }
    var lastEmail: String { get }
    func popView()
    func viewDidLoad()
    func sumDidBeginEditing()
    func sumDidEndEditing()
    func shouldChangeSumCharacters(in range: NSRange,
                                   replacementString string: String) -> Bool
    func shouldChangeEmailCharacters(in range: NSRange,
                                   replacementString string: String) -> Bool
    func pay(onSuccess: @escaping (String) -> (), onFailure: (() -> ())?)
}

// MARK: - Router
protocol PaymentRouterProtocol {
    func popView()
}

// MARK: - Interactor
protocol PaymentInteractorProtocol: class {
    func pay(amount: Int,
             email: String,
             onSuccess: @escaping (String) -> (),
             onFailure: (() -> ())?)
}

// MARK: - Configurator
protocol PaymentConfiguratorProtocol {
    
}
