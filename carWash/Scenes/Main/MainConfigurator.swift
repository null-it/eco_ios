//
//  MainConfigurator.swift
//  carWash
//
//  Created by Juliett Kuroyan on 18.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit

class MainConfigurator: MainConfiguratorProtocol {
    
    var viewController: UIViewController
    
    required init(tabBarController: MainTabBarController) {
        
        let mainView: MainViewController? = MainViewController(nibName: MainViewController.nibName, bundle: nil)
        
        guard let view = mainView else {
            viewController = UIViewController()
            print("error")
            return
        }
        let router = MainRouter(view: view)
        router.tabBarController = tabBarController
        let presenter = MainPresenter(view: view, router: router)
        view.presenter = presenter
        let interactor = MainInteractor(presenter: presenter)
        presenter.interactor = interactor
        viewController = view
    }
}
