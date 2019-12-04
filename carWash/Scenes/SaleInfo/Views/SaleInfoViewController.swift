//
//  SaleInfoViewController.swift
//  carWash
//
//  Created by Juliett Kuroyan on 25.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit

class SaleInfoViewController: UIViewController {
    
    var presenter: SaleInfoPresenterProtocol!
    var configurator: SaleInfoConfiguratorProtocol!
    
    override func viewDidLoad() {
        title = "Акция"
        createBackButton()
    }
    
}


// MARK: - SaleInfoViewProtocol

extension SaleInfoViewController: SaleInfoViewProtocol {
    
}


// MARK: - NavigationBarConfigurationProtocol

extension SaleInfoViewController: NavigationBarConfigurationProtocol {
    
    func backButtonPressed() {
        presenter.popView()
    }
    
}
