//
//  TerminalCell.swift
//  carWash
//
//  Created by Juliett Kuroyan on 10.02.2020.
//  Copyright © 2020 VooDooLab. All rights reserved.
//

import UIKit

class TerminalCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    func set(text: String) {
        label.text = text
    }
}
