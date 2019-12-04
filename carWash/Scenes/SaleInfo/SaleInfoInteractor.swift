//
//  SaleInfoInteractor.swift
//  carWash
//
//  Created by Juliett Kuroyan on 25.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

class SaleInfoInteractor {
    
    unowned var presenter: SaleInfoPresenterProtocol
    
    init(presenter: SaleInfoPresenterProtocol) {
        self.presenter = presenter
    }
    
    
}

// MARK: - SaleInfoInteractorProtocol

extension SaleInfoInteractor: SaleInfoInteractorProtocol {
    
    
}
