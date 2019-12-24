//
//  SalesConfigurator.swift
//  carWash
//
//  Created by Juliett Kuroyan on 25.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit

class SalesConfigurator: SalesConfiguratorProtocol {
    
    var viewController: UIViewController
    
    required init(tabBarController: MainTabBarController) {
        
        let salesView: SalesViewController? = SalesViewController(nibName: SalesViewController.nibName, bundle: nil)
        
        guard let view = salesView else {
            viewController = UIViewController()
            print("error")
            return
        }
        let router = SalesRouter(view: view)
        router.tabBarController = tabBarController
        let presenter = SalesPresenter(view: view, router: router)
        view.presenter = presenter
        let interactor = SalesInteractor(presenter: presenter)
        presenter.interactor = interactor
        viewController = view
    }
}
