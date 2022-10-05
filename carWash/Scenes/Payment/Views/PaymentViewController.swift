//
//  PaymentViewController.swift
//  carWash
//
//  Created by Juliett Kuroyan on 27.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit
import SafariServices
import IQKeyboardManagerSwift
import YooKassaPayments

protocol UIPopPaymentVCDelegate {
    func popped()
}


class PaymentViewController: UIViewController {

    // MARK: - Properties
    
    var presenter: PaymentPresenterProtocol!
    var configurator: PaymentConfiguratorProtocol!
    var paymentTypesInfo: [PaymentTypeInfo] = []
    var delegate: UIPopPaymentVCDelegate? = nil
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var minDepositAmountLabel: UILabel!
    @IBOutlet weak var emailFieldDescriptionLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    
    lazy var alertView: AlertView = .fromNib()!
    private var tokenizationVC: TokenizationModuleInput?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        title = "Оплата"
        minDepositAmountLabel.text = "Минимальная сумма пополнения: \(presenter.minDeposit.toString()) ₽"
        createBackButton()
        configureTableView()
        presenter.viewDidLoad()
        textField.setLeftPadding(16)
        emailTextField.setLeftPadding(16)
        emailTextField.text = presenter.lastEmail
        _ = hideKeyboardWhenTapped()
        textField.delegate = self
        emailTextField.delegate = self
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
    
//    @IBAction func promocodePressed(_ sender: Any) {
//        alertView.set(title: "Введите промокод",
//                     text: "",
//                     okAction: { [self] in
//                        guard let text = alertView.promocodeField.text else {
//                            return
//                        }
//                        self.presenter.promocodeEntered(text)
//                     },
//                     cancelAction: {
//                        print("CANCEL")
//                     },
//                     okButtonTitle: "Применить",
//                     cancelButtonTitle: "Отмена",
//                     isForPromocode: true)
//
//        let window = UIApplication.shared.keyWindow!
//        alertView.frame.size = window.frame.size
//        window.addSubview(alertView)
//    }
    
    // MARK: - Private
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let cellNib = UINib(nibName: PaymentTableViewCell.nibName, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: PaymentTableViewCell.nibName)
        tableView.addObserver(self, forKeyPath: "contentSize", options: .old, context: nil)
        tableView.isScrollEnabled = false
    }

    private func proceedToPayment() {
        
        func paymentSettings() -> TokenizationSettings {
            var paymentMethodTypes: PaymentMethodTypes = []
            paymentMethodTypes.insert(.bankCard)
            paymentMethodTypes.insert(.applePay)
            let tokenizationSettings = TokenizationSettings(paymentMethodTypes: paymentMethodTypes)
            return tokenizationSettings
        }
        
        guard let decimalAmount = Decimal(string: presenter.usersSum) else {
            return
        }
        
        let amount = Amount(value: decimalAmount, currency: .rub)
        
        let settings = paymentSettings()
        
        let tokenizationModuleInputData = TokenizationModuleInputData(clientApplicationKey: paymentToken,
                                                                      shopName: "Car Wash Priority",
                                                                      purchaseDescription: "Пополнение счета",
                                                                      amount: amount,
                                                                      tokenizationSettings: settings,
                                                                      applePayMerchantIdentifier: applePayMerchantIdentifier,
                                                                      isLoggingEnabled: true,
                                                                      savePaymentMethod: .userSelects, customerId: presenter.userPhone)
        
        let inputData: TokenizationFlow = .tokenization(tokenizationModuleInputData)
        
        let viewController = TokenizationAssembly.makeModule(inputData: inputData,
                                                             moduleOutput: self)
        self.tokenizationVC = viewController
        
        present(viewController, animated: true, completion: nil)
    }
    
}


// MARK: - PaymentViewProtocol

extension PaymentViewController: PaymentViewProtocol {
    
    func dismissPaymentView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showInfoAboutError(title: String, message: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
            self.showAlert(message: message, title: title)
        }
        
    }
    
    func startLoader() {
        self.view.activityStartAnimating(activityColor: .lightGray, backgroundColor: UIColor.lightGray.withAlphaComponent(0.5))
    }
    
    func endLoader(with delay: Double) {
        self.view.activityStopAnimating(withDelay: delay)
    }
    
    func showWebView(with url: String) {
        guard let tokenizationVC = tokenizationVC else {
            return
        }
        tokenizationVC.startConfirmationProcess(confirmationUrl: url, paymentMethodType: .bankCard)
//        let vc = WebViewController(html: url)
//        self.presentWithNavBar(vc: vc)
    }
    
    func promocodeMessageReceived(_ message: String, status: PromocodeStatus) {
        alertView.promocodeMessageLabel.text = message
        switch status {
        case .ok:
            alertView.promocodeMessageLabel.textColor = .green
            alertView.okButton.setTitle("Закрыть", for: .normal)
        case .error:
            alertView.promocodeMessageLabel.textColor = .red
        }
    }
    
    func emailIsCorrect(_ value: Bool) {
        emailFieldDescriptionLabel.text = value
            ? "На данную почту вы получите чек об оплате"
            : "Неправильный формат email"
        emailFieldDescriptionLabel.textColor = value ? .systemGray : .red
    }
    
    
    func needMoreMoney(_ value: Bool) {
        minDepositAmountLabel.textColor = value ? .red : .systemGray
    }
    
    
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
//        switch indexPath.row {
//        case 0:
//            proceedToPayment()
//        case 1:
//            ()
//        default:
//            ()
//        }
        tableView.deselectRow(at: indexPath, animated: true)

    }

    private func presentWithNavBar(vc: UIViewController) {
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.navigationBar.topItem?.title = "Оплата"
        navigationController.navigationBar.titleTextAttributes =
            [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .medium)]
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.navigationBar.barTintColor = .white
        navigationController.modalPresentationStyle = .formSheet
        present(navigationController, animated: true, completion: nil)
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
            cell.onPayButtonPressed = {
                self.proceedToPayment()
            }
            return cell
        }
        return UITableViewCell()
    }
    
}


extension PaymentViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.textField {
            return presenter.shouldChangeSumCharacters(in: range, replacementString: string)
        } else {
            return presenter.shouldChangeEmailCharacters(in: range, replacementString: string)
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        presenter.sumDidEndEditing()
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        presenter.sumDidBeginEditing()
    }
    
}

extension PaymentViewController: TokenizationModuleOutput {
    func didFinishConfirmation(paymentMethodType: YooKassaPayments.PaymentMethodType) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
    }
    
    
    func didFinish(on module: TokenizationModuleInput, with error: YooKassaPaymentsError?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
    }
    
    func didSuccessfullyPassedCardSec(on module: TokenizationModuleInput) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func didSuccessfullyConfirmation(paymentMethodType: PaymentMethodType) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
//            if paymentMethodType == .bankCard {
                let content = UNMutableNotificationContent()

                content.title = "Платеж успешно обработан"
//                content.subtitle = ""
                content.body =  "Ожидайте оповещения о поступлении средств на счет"
                content.badge = 1

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.3, repeats: false)

            let request = UNNotificationRequest(identifier: "EcoIosPaymentInfo", content: content, trigger: trigger)
//            }
            self.dismiss(animated: true)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
    
    func tokenizationModule(_ module: TokenizationModuleInput, didTokenize token: Tokens, paymentMethodType: PaymentMethodType) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            var paymentType: PaymentType? = nil
            switch paymentMethodType {
            case .bankCard:
                paymentType = .card
            case .applePay:
                paymentType = .applePay
            default: break
            }
            guard let type = paymentType else { print("pay type is nil"); return }
            self.presenter.paymentTokenReceived(token: token.paymentToken, paymentType: type)
        }
    }
    
}
