//
//  CitiesConfigurator.swift
//  carWash
//
//  Created by Juliett Kuroyan on 26.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit

class CitiesConfigurator: CitiesConfiguratorProtocol {
    
    var viewController: UIViewController
    
    required init() {
        
        let CitiesView: CitiesViewController? = CitiesViewController(nibName: CitiesViewController.nibName, bundle: nil)
        
        guard let view = CitiesView else {
            viewController = UIViewController()
            print("error")
            return
        }
        let router = CitiesRouter(view: view)
        let presenter = CitiesPresenter(view: view, router: router)
        view.presenter = presenter
        let interactor = CitiesInteractor(presenter: presenter)
        presenter.interactor = interactor
        viewController = view
    }
}
