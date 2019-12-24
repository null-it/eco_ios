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
    
    func configure(image: UIImage?,
                   title: String,
                   sum: String) {
        typeImageView.image = image
        titleLabel.text = title
        sumLabel.text = sum
    }
    
}
