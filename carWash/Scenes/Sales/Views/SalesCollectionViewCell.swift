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
    
    lazy var isSE: Bool = {
        let modelName = UIDevice.modelName
        return Constants.SE.contains(modelName)
    }()

    override func awakeFromNib() {
        setShadow()
        if isSE {
            titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        }
    }
    
    private func setShadow() {
        layer.masksToBounds = false
        layer.cornerRadius = 16
        layer.shadowColor = UIColor.black.cgColor

        let width: CGFloat!
        let height: CGFloat!

        if isSE {
            width = SalesViewConstants.saleSECellWidth
            height = SalesViewConstants.saleSECellHeight
        } else {
            let window = UIApplication.shared.keyWindow!
            width = window.frame.width - 2 * SalesViewConstants.standartSpacing
            height = width * SalesViewConstants.saleCellAspectRatio
        }
        let size = CGSize(width: width, height: height)
        bounds.size = size
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 16).cgPath
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 7
    }
    
    func configure(title: String, date: String) {
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

