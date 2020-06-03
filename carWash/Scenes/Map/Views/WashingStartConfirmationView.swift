//
//  TerminalView.swift
//  carWash
//
//  Created by Juliett Kuroyan on 10.02.2020.
//  Copyright © 2020 VooDooLab. All rights reserved.
//

import UIKit

class WashingStartConfirmationView: UIView {
    
    // MARK: - Properties
    
    var startButtonPressed: (() -> ())? = nil
    
    // MARK: - Outlets
    
    @IBOutlet weak var addressLabel: UILabel!
    
    
    // MARK: - Lifecycle

    override func awakeFromNib() {
        roundCorners([.layerMaxXMinYCorner, .layerMinXMinYCorner], radius: 24)
    }
    
    
    // MARK: - Actions

    @IBAction func startButtonPressed(_ sender: Any) {
        startButtonPressed?()
    }
    
    
    // MARK: - Public
    
    func set(address: String) {
        addressLabel.text = address
        addressLabel.sizeToFit()
    }
    
}
