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
    func promocodeMessageReceived(_ message: String, status: PromocodeStatus)
    func showWebView(with url: String)
    func startLoader()
    func endLoader(with delay: Double)
    func showInfoAboutError(title: String, message: String)
    func dismissPaymentView()
}

// MARK: - Presenter
protocol PaymentPresenterProtocol: class {
    var usersSum: String { get }
    var minDeposit: Int { get }
    var lastEmail: String { get }
    var userPhone: String { get }
    func popView()
    func viewDidLoad()
    func sumDidBeginEditing()
    func sumDidEndEditing()
    func paymentTokenReceived(token: String, paymentType: PaymentType)
    func shouldChangeSumCharacters(in range: NSRange,
                                   replacementString string: String) -> Bool
    func shouldChangeEmailCharacters(in range: NSRange,
                                   replacementString string: String) -> Bool
    func promocodeEntered(_ promocode: String)
}

// MARK: - Router
protocol PaymentRouterProtocol {
    func popView()
}

// MARK: - Interactor
protocol PaymentInteractorProtocol: class {
    func pay(amount: Int,
             email: String,
             phone: String,
             token: String,
             paymentType: PaymentType,
             onSuccess: @escaping (String?) -> (),
             onFailure: (() -> ())?)
    func applyPromocode(promocode: String,
                        onSuccess: @escaping (String, PromocodeStatus) -> (),
                        onFailure: (() -> ())?)
}

// MARK: - Configurator
protocol PaymentConfiguratorProtocol {
    
}
