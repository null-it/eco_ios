//
//  OperationsFilterInteractor.swift
//  carWash
//
//  Created by Juliett Kuroyan on 15.01.2020.
//  Copyright © 2020 VooDooLab. All rights reserved.
//

import Foundation

class OperationsFilterInteractor {
    
    unowned var presenter: OperationsFilterPresenterProtocol
    
    init(presenter: OperationsFilterPresenterProtocol) {
        self.presenter = presenter
    }
    
    
}

// MARK: - OperationsFilterInteractorProtocol

extension OperationsFilterInteractor: OperationsFilterInteractorProtocol {
     
}
