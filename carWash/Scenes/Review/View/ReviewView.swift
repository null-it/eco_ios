//
//  reviewView.swift
//  carWash
//
//  Created by Juliett Kuroyan on 29.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit
import Cosmos

class ReviewView: UIView {
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        textField.setLeftPadding(16)
        layer.cornerRadius = 24
        if #available(iOS 11.0, *) {
            layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
    }
    
}
