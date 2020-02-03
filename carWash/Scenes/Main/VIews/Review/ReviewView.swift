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
            configureEmptyDoneButton()
        } else {
            configureDefaultDoneButton()
        }
        
        doneButton.setTitle(title, for: .normal)
        
    }

    // MARK: - Lifecycle

    override func awakeFromNib() {
        self.roundCorners([.layerMaxXMinYCorner, .layerMinXMinYCorner], radius: 24)
        doneButton.borderColor = UIColor(hex: "979797")?.withAlphaComponent(0.2)
    }
    
    
    // MARK: - Actions
    
    @IBAction func reviewButtonPressed(_ sender: Any) {
        reviewButtonPressed?()
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        doneButtonPressed?()
    }
    
    
    // MARK: - Private
    
    private func configureEmptyDoneButton() {
        doneButton.backgroundColor = UIColor(hex: "E1E1E4")?.withAlphaComponent(0.2)
        doneButton.borderWidth = 0
        doneButton.setTitleColor(UIColor(hex: "828282"), for: .normal)
    }
    
    private func configureDefaultDoneButton() {
        doneButton.backgroundColor = .white
        doneButton.borderWidth = 1
        doneButton.setTitleColor(.black, for: .normal)
    }
    
}
