//
//  OnboardingCollectionViewCell.swift
//  carWash
//
//  Created by Juliett Kuroyan on 26.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    var info: OnboardingInfo? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let info = info else {
            return
        }
        descriptionLabel.text = info.description
        photoImageView.image = UIImage(named: info.imagePath)
    }
}
