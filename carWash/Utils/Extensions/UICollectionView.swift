//
//  UICollectionView.swift
//  carWash
//
//  Created by Juliett Kuroyan on 13.12.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit

//extension UICollectionView {
//
//    func setEmptyMessage(_ message: String) {
//        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
//        messageLabel.text = message
//        messageLabel.textColor = .black
//        messageLabel.numberOfLines = 0;
//        messageLabel.textAlignment = .center;
//        messageLabel.font = UIFont(name: "Gilroy-Regular", size: 16)
//        messageLabel.textColor = UIColor(hex: "#7F7F7F")
//        messageLabel.sizeToFit()
//
//        self.backgroundView = messageLabel;
//    }
//
//    func restore() {
//        self.backgroundView = nil
//    }
//}

//
//extension UICollectionViewCell {
//    func enable(on: Bool) {
//        for view in contentView.subviews {
//            view.isUserInteractionEnabled = on
//            view.alpha = on ? 1 : 0.5
//        }
//    }
//}
//
//
extension UITableViewCell {
    func set(enable: Bool) {
        for view in contentView.subviews {
            view.isUserInteractionEnabled = enable
            view.alpha = enable ? 1 : 0.5
        }
    }
}
