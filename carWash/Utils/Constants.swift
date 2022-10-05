//
//  Constants.swift
//  carWash
//
//  Created by Juliett Kuroyan on 12.12.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit

class Constants {
    static let green = UIColor(hex: "93C13D")
    static let pink = UIColor(hex: "FF4768")
    static let blue = UIColor(hex: "007BED")
    static let lightGreen = UIColor(hex: "ADD957")
    static let grey = UIColor(hex: "E0E0E0")
    static let standardSpacing: CGFloat = 30
    static let defaultCornerRadius: CGFloat = 14
    static let minCornerRadius: CGFloat = 7
    static let refreshControlValue: CGFloat = 135
    static let SE = ["iPhone 5s","Simulator iPhone 5s","iPhone SE","Simulator iPhone SE"]
    static let reachabilityViewHeight: CGFloat = 44
    static let messageViewHeight: CGFloat = 64
    static let constraintRequiredPriority: UILayoutPriority = .init(1000)
    static let constraintVeryHeightPriority: UILayoutPriority = .init(999) // :)
    static let constraintHeightPriority: UILayoutPriority = .init(750)
    static let skeletonCrossDissolve = 0.35
    static let fromFormat = "yyyy-MM-dd HH:mm:ss"
    static let toFormatTime = "HH:mm"

}

enum UserDefaultsKeys: String {
    case minReplenish = "min_replenish"
    case email = "email"
    case phone = "phone"
}

let paymentToken = "live_ODE1NDkwEYekHfJloy0IsvoBrAIm89Ls2unpeO8pAMQ"
//let paymentToken = "test_ODE3Mzc3bSTeGFCk7tqWoWOt-jhOzqs0Iza-it3tJik"
let applePayMerchantIdentifier = "merchant.voodoolab.carWash"
