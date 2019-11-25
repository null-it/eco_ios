//
//  MapInteractor.swift
//  carWash
//
//  Created by Juliett Kuroyan on 19.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//


class MapInteractor {
    
    unowned var presenter: MapPresenterProtocol
    
    init(presenter: MapPresenterProtocol) {
        self.presenter = presenter
    }
    
    
}

// MARK: - MapInteractorProtocol

extension MapInteractor: MapInteractorProtocol {
    
    
}
