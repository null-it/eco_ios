//
//  PaymentViewController.swift
//  carWash
//
//  Created by Juliett Kuroyan on 27.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit
import SafariServices

class PaymentViewController: UIViewController {

    // MARK: - Properties
    
    var presenter: PaymentPresenterProtocol!
    var configurator: PaymentConfiguratorProtocol!
    var paymentTypesInfo: [PaymentTypeInfo] = []
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var paymentTypeTitle: UILabel!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        title = "Оплата"
        createBackButton()
        configureTableView()
        presenter.viewDidLoad()
        textField.setLeftPadding(16)
        _ = hideKeyboardWhenTapped()
        textField.delegate = self
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
    
    
    // MARK: - Private
    
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
    
    
    func setSum(text: String) {
        textField.text = text
    }
    
    
    func setTableView(enabled: Bool) {
        tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.set(enable: enabled)
        tableView.cellForRow(at: IndexPath(row: 1, section: 0))?.set(enable: enabled)
        tableView.isUserInteractionEnabled = enabled
        paymentTypeTitle.isEnabled = enabled
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            ()
//            guard let url = URL(string: "https://vk.com") else { return }
//            let svc = SFSafariViewController(url: url)
//            present(svc, animated: true, completion: nil)
        case 1:
            ()
        default:
            ()
        }
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
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


extension PaymentViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return presenter.shouldChangeSumCharacters(in: range, replacementString: string)
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        presenter.sumDidEndEditing()
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        presenter.sumDidBeginEditing()
    }
    
}
