//
//  UIWindow.swift
//  carWash
//
//  Created by Juliett Kuroyan on 29.01.2020.
//  Copyright © 2020 VooDooLab. All rights reserved.
//

import UIKit
import SwiftEntryKit

//MARK: Reachability

extension UIWindow: ReachabilityObserverDelegate {
    
    func reachabilityChanged(_ isReachable: Bool) {
        if !isReachable {
            var attributes = EKAttributes.topToast
            attributes.entryBackground = .color(color: EKColor(Constants.pink!))
            attributes.entranceAnimation = .translation
            attributes.exitAnimation = .translation
            let widthConstraint = EKAttributes.PositionConstraints.Edge.constant(value: frame.width)
            let heightConstraint = EKAttributes.PositionConstraints.Edge.constant(value: Constants.reachabilityViewHeight)
            attributes.positionConstraints.size = .init(width: widthConstraint, height: heightConstraint)
            
            let titleLabel = UILabel()
            titleLabel.text = "Проверьте подключение к интернету"
            titleLabel.textAlignment = .center
            titleLabel.textColor = .white
            titleLabel.font = UIFont.systemFont(ofSize: 14)
                        
            SwiftEntryKit.display(entry: titleLabel, using: attributes)
        }
    }
    
}


