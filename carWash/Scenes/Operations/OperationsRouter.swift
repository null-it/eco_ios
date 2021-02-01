//
//  Router.swift
//  carWash
//
//  Created by Juliett Kuroyan on 15.01.2020.
//  Copyright © 2020 VooDooLab. All rights reserved.
//

import UIKit

class OperationsRouter {
    
    weak var view: OperationsViewController?

    init(view: OperationsViewController?) {
        self.view = view
    }
    
    
}

// MARK: - OperationsRouterProtocol

extension OperationsRouter: OperationsRouterProtocol {

    func popView() {
        view?.navigationController?.popViewController(animated: true)
    }
    
    func presentFilterView(types: [OperationFilter]?,
                           periodFrom: Date?,
                           periodTo: Date?,
                           completion: (([OperationFilter]?, Date?, Date?) -> ())?) {
        guard let view = view else { return }
        let configurator = OperationsFilterConfigurator(types: types,
                                                        periodFrom: periodFrom,
                                                        periodTo: periodTo,
                                                        completion: completion)
        let vc = configurator.viewController
//        view.navigationController?.pushViewController(vc, animated: true)
        view.present(vc, animated: true, completion: nil)
    }
    
}
