//
//  OperationsFilterConfigurator.swift
//  carWash
//
//  Created by Juliett Kuroyan on 15.01.2020.
//  Copyright © 2020 VooDooLab. All rights reserved.
//

import UIKit

class OperationsFilterConfigurator: OperationsFilterConfiguratorProtocol {
    
    var viewController: UIViewController
    
    required init(types: [OperationFilter]?,
                  periodFrom: Date?,
                  periodTo: Date?,
                  completion: (([OperationFilter]?, Date?, Date?) -> ())?) {
        
        let operationsFilterView: OperationsFilterViewController? = OperationsFilterViewController(nibName: OperationsFilterViewController.nibName, bundle: nil)
        
        guard let view = operationsFilterView else {
            viewController = UIViewController()
            print("error")
            return
        }
        let router = OperationsFilterRouter(view: view)
        let presenter = OperationsFilterPresenter(view: view, router: router)
        view.presenter = presenter
        presenter.operations = types
        presenter.periodFrom = periodFrom
        presenter.periodTo = periodTo
        presenter.completion = completion
        
        let navigationController = UINavigationController(rootViewController: view)
        navigationController.navigationBar.topItem?.title = "Фильтры"
        navigationController.navigationBar.titleTextAttributes =
            [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .medium)] 
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.navigationBar.barTintColor = .white
        navigationController.modalPresentationStyle = .formSheet
        viewController = navigationController
    }
    
}
