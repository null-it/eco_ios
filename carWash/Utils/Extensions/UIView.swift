//
//  UIView.swift
//  carWash
//
//  Created by Juliett Kuroyan on 25.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit

extension UIView {
    
    static var nibName: String {
        return String(describing: self)
    }
    
    
    class func fromNib<T: UIView>() -> T? {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)?[0] as? T
    }
    
    
    func roundCorners(_ corners: CACornerMask, radius: CGFloat) {
        if #available(iOS 11, *) {
            self.layer.cornerRadius = radius
            self.layer.maskedCorners = corners
        } else {
//            var cornerMask = UIRectCorner()
//            if(corners.contains(.layerMinXMinYCorner)){
//                cornerMask.insert(.topLeft)
//            }
//            if(corners.contains(.layerMaxXMinYCorner)){
//                cornerMask.insert(.topRight)
//            }
//            if(corners.contains(.layerMinXMaxYCorner)){
//                cornerMask.insert(.bottomLeft)
//            }
//            if(corners.contains(.layerMaxXMaxYCorner)){
//                cornerMask.insert(.bottomRight)
//            }
//
//            let path = UIBezierPath(roundedRect: self.bounds,
//                                    byRoundingCorners: cornerMask,
//                                    cornerRadii: CGSize(width: radius, height: radius))
//            let mask = CAShapeLayer()
//            mask.bounds = self.frame
//            mask.position = self.center
//            mask.path = path.cgPath
//            self.layer.mask = mask
            self.layer.cornerRadius = radius
        }
        
        
    }
}
