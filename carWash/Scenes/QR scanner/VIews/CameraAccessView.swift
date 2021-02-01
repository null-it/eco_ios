//
//  CameraAccessView.swift
//  carWash
//
//  Created by Juliett Kuroyan on 17.02.2020.
//  Copyright © 2020 VooDooLab. All rights reserved.
//

import UIKit

class CameraAccessView: UIView {
    
    @IBAction func allowButtonPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
    }
}
