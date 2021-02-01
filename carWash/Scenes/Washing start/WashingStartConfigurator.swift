//
//  WashingStartConfigurator.swift
//  carWash
//
//  Created by Juliett Kuroyan on 06.02.2020.
//  Copyright © 2020 VooDooLab. All rights reserved.
//

import UIKit

class WashingStartConfigurator: WashingStartConfiguratorProtocol {
    
    var viewController: UIViewController
    
    required init() {
        
        let operationsView: WashingStartViewController? = WashingStartViewController(nibName: WashingStartViewController.nibName, bundle: nil)
        
        guard let view = operationsView else {
            viewController = UIViewController()
            print("error")
            return
        }
        let router = WashingStartRouter(view: view)
        let presenter = WashingStartPresenter(view: view, router: router)
        view.presenter = presenter
        viewController = view
    }
}
