//
//  MapConfigurator.swift
//  carWash
//
//  Created by Juliett Kuroyan on 19.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit

class MapConfigurator: MapConfiguratorProtocol {
    
    var viewController: UIViewController
    
    required init(isAuthorized: Bool) {
        
        let MapView: MapViewController? = MapViewController(nibName: MapViewController.nibName, bundle: nil)
        
        guard let view = MapView else {
            viewController = UIViewController()
            print("error")
            return
        }
        view.isAuthorized = isAuthorized
        let router = MapRouter(view: view)
        let presenter = MapPresenter(view: view, router: router)
        presenter.isAuthorized = isAuthorized
        view.presenter = presenter
        let interactor = MapInteractor(presenter: presenter)
        presenter.interactor = interactor
        viewController = view
    }
}
