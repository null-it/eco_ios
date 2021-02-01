//
//  WashingInfoSaleCell.swift
//  carWash
//
//  Created by Juliett Kuroyan on 28.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit

class WashingInfoSaleCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func configure(title: String, date: String) {
        titleLabel.text = title
        dateLabel.text = date
    }

}
