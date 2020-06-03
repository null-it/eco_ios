//
//  OperationsFilterConfigurator.swift
//  carWash
//
//  Created by Juliett Kuroyan on 15.01.2020.
//  Copyright © 2020 VooDooLab. All rights reserved.
//

import UIKit

class OperationsConfigurator: OperationsConfiguratorProtocol {
    
    var viewController: UIViewController
    
    required init() {
        
        let operationsView: OperationsViewController? = OperationsViewController(nibName: OperationsViewController.nibName, bundle: nil)
        
        guard let view = operationsView else {
            viewController = UIViewController()
            print("error")
            return
        }
        let router = OperationsRouter(view: view)
        let presenter = OperationsPresenter(view: view, router: router)
        view.presenter = presenter
        let interactor = OperationsInteractor(presenter: presenter)
        presenter.interactor = interactor
        viewController = view
    }
}
