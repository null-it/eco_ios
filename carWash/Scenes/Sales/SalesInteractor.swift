//
//  SalesInteractor.swift
//  carWash
//
//  Created by Juliett Kuroyan on 25.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

class SalesInteractor {
    
    unowned var presenter: SalesPresenterProtocol
    
    init(presenter: SalesPresenterProtocol) {
        self.presenter = presenter
    }
    
    
}

// MARK: - SalesInteractorProtocol

extension SalesInteractor: SalesInteractorProtocol {
    
    
}
