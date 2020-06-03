//
//  ReviewTextView.swift
//  carWash
//
//  Created by Juliett Kuroyan on 29.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit

class ReviewTextView: UIView {
    
    // MARK: - Properties

    var doneButtonPressed: ((String) -> ())?
    
    
    // MARK: - Outlets

    @IBOutlet weak var textView: UITextView!
    
    
    func configure() {
        textView.becomeFirstResponder()
    }

    // MARK: - Actions
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        doneButtonPressed?(textView.text)
    }
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        self.roundCorners([.layerMaxXMinYCorner, .layerMinXMinYCorner], radius: 22)
    }
    
}
