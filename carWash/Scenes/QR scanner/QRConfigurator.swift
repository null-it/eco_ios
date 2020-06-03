//
//  QRConfigurator.swift
//  carWash
//
//  Created by Juliett Kuroyan on 03.02.2020.
//  Copyright © 2020 VooDooLab. All rights reserved.
//

import UIKit

class QRConfigurator: QRConfiguratorProtocol {
    
    var viewController: UIViewController
    
    required init() {
        let QRView: QRViewController? = QRViewController(nibName: QRViewController.nibName, bundle: nil)
        
        guard let view = QRView else {
            viewController = UIViewController()
            print("error")
            return
        }
        let router = QRRouter(view: view)
        let presenter = QRPresenter(view: view, router: router)
        view.presenter = presenter
        let interactor = QRInteractor(presenter: presenter)
        presenter.interactor = interactor
        viewController = view
    }
    
}
