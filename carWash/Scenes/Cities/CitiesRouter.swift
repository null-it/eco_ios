//
//  CitiesRouter.swift
//  carWash
//
//  Created by Juliett Kuroyan on 26.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit

class CitiesRouter {
    
    weak var view: CitiesViewController?
    
    init(view: CitiesViewController?) {
        self.view = view
    }
    
    
}

// MARK: - CitiesRouterProtocol

extension CitiesRouter: CitiesRouterProtocol {
    
    func popView() {
        view?.navigationController?.popViewController(animated: true)
    }
    
    
//    func presentProfileView() {
//        guard let view = view else { return }
//        let vc = MainTabBarController()
//        vc.modalPresentationStyle = .fullScreen
//        view.present(vc, animated: true, completion: nil)
//    }
  
}
