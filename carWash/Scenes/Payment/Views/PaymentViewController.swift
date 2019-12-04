//
//  PaymentViewController.swift
//  carWash
//
//  Created by Juliett Kuroyan on 27.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController {
        
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    var presenter: PaymentPresenterProtocol!
    var configurator: PaymentConfiguratorProtocol!
    
    var paymentTypesInfo: [PaymentTypeInfo] = []
    
    override func viewDidLoad() {
        title = "Оплата"
        createBackButton()
        configureTableView()
        presenter.viewDidLoad()
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let object = object as? UITableView {
            if object == tableView {
                tableViewHeightConstraint.constant = tableView.contentSize.height
            }
        }
    }
    
    
    deinit {
        tableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let cellNib = UINib(nibName: PaymentTableViewCell.nibName, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: PaymentTableViewCell.nibName)
        tableView.addObserver(self, forKeyPath: "contentSize", options: .old, context: nil)
        tableView.isScrollEnabled = false
    }
}


// MARK: - PaymentViewProtocol

extension PaymentViewController: PaymentViewProtocol {
    
    func updateFor(info: [PaymentTypeInfo]) {
        paymentTypesInfo = info
    }
    
}


// MARK - NavigationBarConfigurationProtocol

extension PaymentViewController: NavigationBarConfigurationProtocol {
    
    func backButtonPressed() {
        presenter.popView()
    }
    
}


// MARK: - UITableViewDelegate

extension PaymentViewController: UITableViewDelegate {
    
}


// MARK: - UITableViewDataSource

extension PaymentViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentTypesInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: PaymentTableViewCell.nibName, for: indexPath) as? PaymentTableViewCell {
            let info = paymentTypesInfo[indexPath.row]
            cell.update(for: info)
            return cell
        }
        return UITableViewCell()
    }
    
}
