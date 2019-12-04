//
//  PaymentRouter.swift
//  carWash
//
//  Created by Juliett Kuroyan on 27.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit

class PaymentRouter {
    
    weak var view: PaymentViewController?
    
    init(view: PaymentViewController?) {
        self.view = view
    }
    
    
}

// MARK: - PaymentRouterProtocol

extension PaymentRouter: PaymentRouterProtocol {

    func popView() {
        view?.navigationController?.popViewController(animated: true)
    }
    
}
