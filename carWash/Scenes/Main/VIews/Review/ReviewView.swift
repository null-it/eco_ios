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
    
    // MARK: - Properties
    
    var reviewButtonPressed: (() -> ())?
    var doneButtonPressed: (() -> ())?
    var ratingDidChanged: ((Double) -> ())?

    // MARK: - Outlets

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var doneButton: UIButton!
    
    func configure(price: String, date: String, address: String) {
        priceLabel.text = price
        dateLabel.text = date
        addressLabel.text = address
        ratingView.didFinishTouchingCosmos = {[weak self] (rating) in
            self?.ratingDidChanged?(rating)
        }
    }
    
    func set(text: String) {
        var title = text
        if text.isEmpty {
           title = "Напишите отзыв"
        }
        
        doneButton.setTitle(title, for: .normal)

    }

    // MARK: - Lifecycle

    override func awakeFromNib() {
        self.roundCorners([.layerMaxXMinYCorner, .layerMinXMinYCorner], radius: 24)
    }
    
    
    // MARK: - Actions
    
    @IBAction func reviewButtonPressed(_ sender: Any) {
        reviewButtonPressed?()
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        doneButtonPressed?()
    }
    
}
