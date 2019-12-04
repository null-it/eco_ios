//
//  OnboardingProtocols.swift
//  carWash
//
//  Created by Juliett Kuroyan on 26.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import Foundation

// MARK: - View
protocol OnboardingViewProtocol: class {
    func updateFor(info: [OnboardingInfo])
    func set(page: Int) 
}

// MARK: - Presenter
protocol OnboardingPresenterProtocol: class {
    func popView()
    func viewDidLoad()
    func nextButtonPressed()
    func skipButtonPressed()
    func currentPageDidChange(_ page: Int)
}

// MARK: - Router
protocol OnboardingRouterProtocol {
    func popView()
    func presentLoginView()
}

// MARK: - Configurator
protocol OnboardingConfiguratorProtocol {
    
}
