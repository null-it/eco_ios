//
//  MainInteractor.swift
//  carWash
//
//  Created by Juliett Kuroyan on 18.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import Foundation

class MainInteractor {
    
    unowned var presenter: MainPresenterProtocol
    
    init(presenter: MainPresenterProtocol) {
        self.presenter = presenter
    }
    
    
}

// MARK: - MainInteractorProtocol

extension MainInteractor: MainInteractorProtocol {
    
    
}
