//
//  CashbackCollectionViewCell.swift
//  carWash
//
//  Created by Juliett Kuroyan on 27.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit

enum CashbackGroup {
    case available, current
}

struct CashbackTypeInfo {
    var groups: [CashbackGroup]
    var title: String
}

class CashbackCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(info: CashbackTypeInfo) {
        titleLabel.text = info.title
        var textColor = MainSceneConstants.cashbackCellUnavailableColor
        var isShadowEnabled = false
        
        info.groups.forEach { (group) in
            switch group {
            case .available:
                textColor = MainSceneConstants.cashbackCellAvailableColor
            case .current:
                isShadowEnabled = true
                textColor = MainSceneConstants.cashbackCellAvailableColor
            }
        }

        set(fontSize: MainSceneConstants.cashbackCellDefaultFontSize, textColor: textColor, isShadowEnabled: isShadowEnabled)
    }
    
    private func set(fontSize: CGFloat,
                     textColor: UIColor,
                     isShadowEnabled: Bool) {
        titleLabel.font = titleLabel.font.withSize(fontSize)
        titleLabel.textColor = textColor
        if isShadowEnabled {
            configureShadow()
            backgroundColor = .white
        }
    }
    
    private func configureShadow() {
        layer.masksToBounds = false
        layer.cornerRadius = MainSceneConstants.cashbackCellCornerRadius
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: MainSceneConstants.cashbackCellCornerRadius).cgPath
        layer.shadowOpacity = MainSceneConstants.cashbackCellShadowOpacity
        layer.shadowRadius = MainSceneConstants.cashbackCellShadowRadius
    }
    
}
