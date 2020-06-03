//
//  CitiesTableViewCell.swift
//  carWash
//
//  Created by Juliett Kuroyan on 16.12.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit

class CitiesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameTitle: UILabel!
    @IBOutlet weak var isCurrentCityImage: UIImageView!
    
    func configure(cityName: String, isCurrent: Bool) {
        nameTitle.text = cityName
        isCurrentCityImage.isHidden = !isCurrent
    }
    
}
