//
//  SaleInfoViewController.swift
//  carWash
//
//  Created by Juliett Kuroyan on 25.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit

class SaleInfoViewController: UIViewController {
    
    
    // MARK: - Properties
    
    var presenter: SaleInfoPresenterProtocol!
    var configurator: SaleInfoConfiguratorProtocol!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        title = "Акция"
        createBackButton()
    }
    
    
    // MARK: - Actions
    
    @IBAction func addressButtonPressed(_ sender: Any) {
        presenter.addressButtonPressed()
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
