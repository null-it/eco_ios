//
//  OnboardingConfigurator.swift
//  carWash
//
//  Created by Juliett Kuroyan on 26.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit

class OnboardingConfigurator: OnboardingConfiguratorProtocol {
    
    var viewController: UIViewController
    
    required init() {
        let OnboardingView: OnboardingViewController? = OnboardingViewController(nibName: OnboardingViewController.nibName, bundle: nil)
        
        guard let view = OnboardingView else {
            viewController = UIViewController()
            print("error")
            return
        }
        let router = OnboardingRouter(view: view)
        let presenter = OnboardingPresenter(view: view, router: router)
        view.presenter = presenter
        viewController = view
    }
}
