//
//  HappyHoursInfoView.swift
//  carWash
//
//  Created by Juliett Kuroyan on 30.01.2020.
//  Copyright © 2020 VooDooLab. All rights reserved.
//

import UIKit

class HappyHoursInfoView: UIView {
    
    @IBOutlet weak var textView: UITextView!
    
    
    @IBAction func okButtonPressed(_ sender: Any) {
        removeFromSuperview()
    }
    
    func set(text: String) {
        textView.text = text
        textView.scrollRangeToVisible(NSRange(location:0, length:0))
    }
    
    
}
