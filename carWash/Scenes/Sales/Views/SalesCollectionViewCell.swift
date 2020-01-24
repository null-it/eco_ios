//
//  SalesViewCell.swift
//  carWash
//
//  Created by Juliett Kuroyan on 25.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit

class SalesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    private func setShadow() {
        layer.masksToBounds = false
        layer.cornerRadius = 16
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 16).cgPath
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 7
    }
    
    func configure(title: String, date: String) {
        setShadow()
        titleLabel.text = title
        dateLabel.text = date
    }
    
    func setImage(_ image: UIImage?) {
        if let image = image {
            imageView.image = image
        } else {
            imageView.image = UIImage(named: "empty")
        }
    }

//    override func awakeFromNib() {
//        imageView.roundCorners(topLeft: Constants.defaultCornerRadius,
//                               topRight: Constants.defaultCornerRadius,
//                               bottomLeft: Constants.minCornerRadius,
//                               bottomRight: Constants.defaultCornerRadius)
//        roundCorners(topLeft: Constants.defaultCornerRadius,
//                      topRight: Constants.defaultCornerRadius,
//                      bottomLeft: Constants.minCornerRadius,
//                      bottomRight: Constants.defaultCornerRadius)
//    }
    
}

