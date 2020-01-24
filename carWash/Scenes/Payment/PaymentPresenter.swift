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
    let rub = " ₽"
    
    var paymentTypes = [
        PaymentTypeInfo(title: "Картой в приложении", isEnabled: false),
        PaymentTypeInfo(title: "Apple Pay", isEnabled: false)
    ]
    
    init(view: PaymentViewProtocol,
         router: PaymentRouterProtocol) {
        self.view = view
        self.router = router
        
    }    
    
}


// MARK: - PaymentPresenterProtocol

extension PaymentPresenter: PaymentPresenterProtocol {
    
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
        view.setTableView(enabled: !sum.isEmpty)
        
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
