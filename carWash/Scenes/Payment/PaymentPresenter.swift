//
//  PaymentPresenter.swift
//  carWash
//
//  Created by Juliett Kuroyan on 27.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import Foundation

class PaymentPresenter {
    
    // MARK: - Properties
    
    unowned let view: PaymentViewProtocol
    var interactor: PaymentInteractorProtocol!
    let router: PaymentRouterProtocol
    var sum = ""
    var email = ""
    let rub = " ₽"
    var phone = UserDefaults.standard.value(forKey: UserDefaultsKeys.phone.rawValue) as? String
    let _minDeposit = UserDefaults.standard.value(forKey: UserDefaultsKeys.minReplenish.rawValue) as! Int
    let savedEmail = UserDefaults.standard.value(forKey: UserDefaultsKeys.email.rawValue) as? String
    var isEmailEntered: Bool = false
    var isDepositEntered: Bool = false
    
    var paymentTypes = [
        PaymentTypeInfo(title: "Оплатить", isEnabled: false),
    ]
    
    init(view: PaymentViewProtocol,
         router: PaymentRouterProtocol) {
        self.view = view
        self.router = router
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let regex = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" +
            "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
            "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" +
            "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" +
            "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
            "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
            "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return emailPredicate.evaluate(with: email)
    }
    
}


// MARK: - PaymentPresenterProtocol

extension PaymentPresenter: PaymentPresenterProtocol {
    var userPhone: String {
        get {
            return self.phone == nil ? "" : self.phone!
        }
    }
    
    
    var usersSum: String {
        get {
            return self.sum
        }
    }
    
    func paymentTokenReceived(token: String, paymentType: PaymentType) {
        guard let amount = Int(sum) else { return }
        let onRequestSuccess: ((String?) -> ()) = { [weak self] message in
            UserDefaults.standard.set(self?.email, forKey: "email")
            
//            self?.view.endLoader(with: 0.5)
            if let url = message {
                self?.view.showWebView(with: url)
            } else {
                self?.view.dismissPaymentView()
            }
        }
        let onFailure: (() -> Void)? = { [weak self] in
            self?.view.showInfoAboutError(title: "Ошибка", message: "Попробуйте позже")
//            self?.view.endLoader(with: 0.5)
        }
//        self.view.startLoader()
        interactor.pay(amount: amount, email: email, phone: userPhone,token: token, paymentType: paymentType, onSuccess: onRequestSuccess, onFailure: onFailure)
    }
    
    func promocodeEntered(_ promocode: String) {
        interactor.applyPromocode(promocode: promocode) { (message, status) in
            self.view.promocodeMessageReceived(message, status: status)
        } onFailure: {
            print("an error occured")
        }
    }
    
    func shouldChangeEmailCharacters(in range: NSRange, replacementString string: String) -> Bool {
        guard let textRange = Range(range, in: email) else {
            return false
        }
        email = email.replacingCharacters(in: textRange, with: string).withoutLineBreakSymbols()
        print("emai is: \(email)")
        if isValidEmail(email) {
            view.emailIsCorrect(true)
            isEmailEntered = true
            view.setTableView(enabled: isDepositEntered ? true : false)
        } else {
            isEmailEntered = false
            view.emailIsCorrect(false)
            view.setTableView(enabled: false)
        }
        
        return true
    }
    
    var minDeposit: Int {
        get {
            return _minDeposit
        }
    }
    
    var lastEmail: String {
        get {
            if savedEmail != nil {
                email = savedEmail!
                isEmailEntered = true
            }
            return savedEmail != nil ? savedEmail! : ""
        }
    }
    
    func sumDidBeginEditing() {
        guard !sum.isEmpty else { return }
        view.setSum(text: sum)
    }
    
    
    func sumDidEndEditing() {
        guard !sum.isEmpty else { return }
        let sumRub = sum + rub
        view.setSum(text: sumRub)
    }
    
    
    func shouldChangeSumCharacters(in range: NSRange, replacementString string: String) -> Bool {
        guard let textRange = Range(range, in: sum) else {
            return false
            
            
        }
        sum = sum.replacingCharacters(in: textRange, with: string).withoutLineBreakSymbols()
        guard !sum.isEmpty else {
            view.setTableView(enabled: false)
            return true
        }
        guard let intSum = sum.toInt() else {
            return true
        }
        print("int sum: \(intSum)")
        if intSum < _minDeposit {
            view.needMoreMoney(true)
            isDepositEntered = false
            view.setTableView(enabled: false)
        } else {
            view.needMoreMoney(false)
            isDepositEntered = true
            view.setTableView(enabled: isEmailEntered ? true : false)
        }
        
        return true
    }
    
    
    func viewDidLoad() {
        view.updateFor(info: paymentTypes)
        view.setTableView(enabled: false)
    }
    
    
    func popView() {
        router.popView()
    }
    
}
