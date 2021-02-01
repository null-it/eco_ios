//
//  QRRouter.swift
//  carWash
//
//  Created by Juliett Kuroyan on 03.02.2020.
//  Copyright © 2020 VooDooLab. All rights reserved.
//

import UIKit

class QRRouter {
    
    weak var view: QRViewController?

    init(view: QRViewController?) {
        self.view = view
    }
    
}


// MARK: - QRRouterProtocol

extension QRRouter: QRRouterProtocol {
    
    func popView() {
        view?.navigationController?.popViewController(animated: true)
    }
    
}
