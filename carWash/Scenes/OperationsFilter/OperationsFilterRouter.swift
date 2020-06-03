//
//  Router.swift
//  carWash
//
//  Created by Juliett Kuroyan on 15.01.2020.
//  Copyright © 2020 VooDooLab. All rights reserved.
//

import UIKit

class OperationsFilterRouter {
    
    weak var view: OperationsFilterViewController?

    init(view: OperationsFilterViewController?) {
        self.view = view
    }
    
}

// MARK: - OperationsFilterRouterProtocol

extension OperationsFilterRouter: OperationsFilterRouterProtocol {

    func popView() {
        view?.dismiss(animated: true, completion: nil)
    }
    
}
