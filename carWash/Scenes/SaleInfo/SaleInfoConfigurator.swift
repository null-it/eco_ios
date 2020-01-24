//
//  SaleInfoConfigurator.swift
//  carWash
//
//  Created by Juliett Kuroyan on 25.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit

class SaleInfoConfigurator: SaleInfoConfiguratorProtocol {
    
    var viewController: UIViewController
    
    required init(id: Int) {
        
        let saleInfoView: SaleInfoViewController? = SaleInfoViewController(nibName: SaleInfoViewController.nibName, bundle: nil)
        
        guard let view = saleInfoView else {
            viewController = UIViewController()
            print("error")
            return
        }
        let router = SaleInfoRouter(view: view)
        let presenter = SaleInfoPresenter(view: view, router: router)
        view.presenter = presenter
        let interactor = SaleInfoInteractor(presenter: presenter)
        presenter.interactor = interactor
        presenter.id = id
        viewController = view
    }
}
