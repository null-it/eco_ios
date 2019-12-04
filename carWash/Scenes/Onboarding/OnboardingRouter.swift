//
//  OnboardingRouter.swift
//  carWash
//
//  Created by Juliett Kuroyan on 26.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit

class OnboardingRouter {
    
    weak var view: OnboardingViewController?
    
    init(view: OnboardingViewController?) {
        self.view = view
    }
    
    
}

// MARK: - OnboardingRouterProtocol

extension OnboardingRouter: OnboardingRouterProtocol {

    func popView() {
        view?.navigationController?.popViewController(animated: true)
    }
    
    func presentLoginView() {
        guard let view = view else { return }
        let configurator = LoginConfigurator()
        let vc = configurator.viewController
        if let navigationController = view.navigationController {
            navigationController.pushViewController(vc, animated: true)
        } else {
            vc.modalPresentationStyle = .fullScreen
            view.present(vc, animated: true, completion: nil)
        }
    }
    
  
}
