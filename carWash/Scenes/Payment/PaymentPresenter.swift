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
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
}


// MARK: - PaymentPresenterProtocol

extension PaymentPresenter: PaymentPresenterProtocol {
    
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
        email = email.replacingCharacters(in: textRange, with: string)
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
            return savedEmail != nil ? savedEmail! : ""
        }
    }
    
    func pay(onSuccess: @escaping (String) -> (), onFailure: (() -> ())?) {
        guard let amount = Int(sum) else { return }
        interactor.pay(amount: amount, email: email, onSuccess: onSuccess, onFailure: onFailure)
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
        sum = sum.replacingCharacters(in: textRange, with: string)
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
