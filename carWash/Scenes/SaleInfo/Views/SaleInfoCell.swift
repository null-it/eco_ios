//
//  SaleInfoCell.swift
//  carWash
//
//  Created by Juliett Kuroyan on 25.12.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit

class SaleInfoCell: UITableViewCell {
    
    @IBOutlet weak var button: LeftAlignedIconButton!
    
    var buttonPressed: (() -> ())?
    
    func update(for info: WashResponse, action: @escaping () -> ()) {
        button.setTitle(info.address, for: .normal)
        buttonPressed = action
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        buttonPressed?()
    }

}
