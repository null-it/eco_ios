//
//  PaymentCollectionViewCell.swift
//  carWash
//
//  Created by Juliett Kuroyan on 27.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit

class PaymentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleTextField: UILabel!
    
    func update(for info: PaymentTypeInfo) {
        titleTextField.text = info.title
        self.set(enable: info.isEnabled)
    }
    
}
