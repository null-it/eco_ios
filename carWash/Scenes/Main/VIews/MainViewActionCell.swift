//
//  MainViewActionCell.swift
//  carWash
//
//  Created by Juliett Kuroyan on 18.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit

class MainViewActionCell: UITableViewCell {
    
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sumLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    func configure(image: UIImage?,
                   title: String,
                   sum: String,
                   time: String) {
        typeImageView.image = image
        titleLabel.text = title
        sumLabel.text = sum
        timeLabel.text = time
    }
    
}
