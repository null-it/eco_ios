//
//  PaymentCollectionViewCell.swift
//  carWash
//
//  Created by Juliett Kuroyan on 27.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit

class PaymentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var payButton: UIButton!
    
    var onPayButtonPressed: (() -> Void)?
    
    func update(for info: PaymentTypeInfo) {
        payButton.setTitle(info.title, for: .normal)
        self.set(enable: info.isEnabled)
    }
    
    @IBAction func payButtonPressed(_ sender: Any) {
        onPayButtonPressed?()
    }
}
