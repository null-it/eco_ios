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
    
    
    private func setShadow() { // !
        layer.masksToBounds = false
        layer.cornerRadius = 16
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 16).cgPath
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 7
    }
    
    func configure(data: SaleResponseData) {
        imageView.image = UIImage(named: "empty")
        setShadow()
        titleLabel.text = data.title
        guard !data.logo.isEmpty else { return }
        let url = URL(string: data.logo)
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url!) {
                DispatchQueue.main.async { [weak self] in
                    if let image = UIImage(data: data) {
                        self?.imageView.image = image
                    }
                }
            }
        }
    }
    
}

