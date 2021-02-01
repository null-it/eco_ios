//
//  PaymentConfigurator.swift
//  carWash
//
//  Created by Juliett Kuroyan on 27.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit

class PaymentConfigurator: PaymentConfiguratorProtocol {
    
    var viewController: UIViewController
    
    required init() {
        let paymentView: PaymentViewController? = PaymentViewController(nibName: PaymentViewController.nibName, bundle: nil)
        guard let view = paymentView else {
            viewController = UIViewController()
            print("error")
            return
        }
        let router = PaymentRouter(view: view)
        let presenter = PaymentPresenter(view: view, router: router)
        view.presenter = presenter
        let interactor = PaymentInteractor(presenter: presenter)
        presenter.interactor = interactor
        viewController = view
    }
}
