//
//  MainRouter.swift
//  carWash
//
//  Created by Juliett Kuroyan on 18.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit

class MainRouter {
    
    weak var view: MainViewController?
    
    init(view: MainViewController?) {
        self.view = view
    }
    
    
}

// MARK: - MainRouterProtocol

extension MainRouter: MainRouterProtocol {

  
}
