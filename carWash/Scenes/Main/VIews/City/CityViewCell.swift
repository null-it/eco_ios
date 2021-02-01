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
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var isSelectedCheckBox: BEMCheckBox!
    
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        isSelectedCheckBox.onAnimationType = .oneStroke
        isSelectedCheckBox.offAnimationType = .oneStroke
    }
    
    
    // MARK: - Properties
    
    var valueChanged: ((Bool) -> ())?
    
    // MARK: - Actions
    
    @IBAction func checkBoxValueChanged(_ sender: Any) {
        valueChanged?(isSelectedCheckBox.on)
    }
    
    
    func configure(name: String, isSelected: Bool) {
        nameLabel.text = name
        isSelectedCheckBox.on = isSelected
    }
    
    
    func set(selected: Bool) {
        isSelectedCheckBox.on = selected
    }
    
}
