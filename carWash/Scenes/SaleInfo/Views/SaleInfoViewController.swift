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
    var washes: [WashResponse] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        navigationController?.navigationBar.isHidden = false
        title = "Акция"
        createBackButton()
        configureTableView()
    }
    
    override func viewDidLayoutSubviews() {
        logoImageView.roundCorners(topLeft: Constants.defaultCornerRadius,
                                   topRight: Constants.defaultCornerRadius,
                                   bottomLeft: Constants.minCornerRadius,
                                   bottomRight: Constants.defaultCornerRadius)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let object = object as? UITableView {
            if object == tableView {
                tableViewHeight.constant = tableView.contentSize.height
            }
        }
    }
    
    deinit {
        tableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    
    // MARK: - Private
    
    private func configureTableView() {
        tableView.dataSource = self
        let cellNib = UINib(nibName: SaleInfoCell.nibName, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: SaleInfoCell.nibName)
        tableView.addObserver(self, forKeyPath: "contentSize", options: .old, context: nil)
        tableView.isScrollEnabled = false
    }
    
}


// MARK: - SaleInfoViewProtocol

extension SaleInfoViewController: SaleInfoViewProtocol {
    
    func updateInfo(sale: SaleResponse) {
        titleLabel?.backgroundColor = .clear
        textLabel?.backgroundColor = .clear
        titleLabel?.text = sale.title
        textLabel?.text = sale.text
        washes = sale.washes ?? []
        guard !sale.logo.isEmpty else { return }
        let url = URL(string: sale.logo)
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url!) {
                DispatchQueue.main.async { [weak self] in
                    if let image = UIImage(data: data) {
                        self?.logoImageView.image = image
                    }
                }
            }
        }
    }
    
}


// MARK: - NavigationBarConfigurationProtocol

extension SaleInfoViewController: NavigationBarConfigurationProtocol {
    
    func backButtonPressed() {
        presenter.popView()
    }
    
}


// MARK: - UITableViewDataSource

extension SaleInfoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        washes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: SaleInfoCell.nibName, for: indexPath) as? SaleInfoCell {
            let info = washes[indexPath.row]
            cell.update(for: info, action: { [weak self] in
                self?.presenter.addressButtonPressed(row: indexPath.row)
            })
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        SaleInfoConstants.addressCellHeight
    }
    
}
