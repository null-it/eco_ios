//
//  CityViewCell.swift
//  carWash
//
//  Created by Juliett Kuroyan on 24.12.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit
import BEMCheckBox

class CityViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var isSelectedCheckBox: BEMCheckBox!
    var valueChanged: ((Bool) -> ())?
    
    func configure(name: String, isSelected: Bool) {
        nameLabel.text = name
        isSelectedCheckBox.on = isSelected
    }
    
    @IBAction func checkBoxValueChanged(_ sender: Any) {
        valueChanged?(isSelectedCheckBox.on)
    }
    
    func set(selected: Bool) {
        isSelectedCheckBox.on = selected
    }
}
