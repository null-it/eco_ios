//
//  AlertView.swift
//  carWash
//
//  Created by Juliett Kuroyan on 11.02.2020.
//  Copyright © 2020 VooDooLab. All rights reserved.
//

import UIKit

class AlertView: UIView {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var separatorView: UIView!
    
    // MARK: - Properties
    
    private var okAction: (()->())? = nil
    private var cancelAction: (()->())? = nil

    
    // MARK: - Actions
    
    @IBAction func okButtonPressed(_ sender: Any) {
        okAction?()
        removeFromSuperview()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        cancelAction?()
        removeFromSuperview()
    }
    
    // MARK: - Public
    
    func set(title: String,
             text: String,
             okAction: (()->())? = nil,
             cancelAction: (()->())? = nil,
             okButtonTitle: String,
             cancelButtonTitle: String) {
        
        let isCancelButtonHidden = cancelAction == nil
        cancelButton.isHidden = isCancelButtonHidden
        separatorView.isHidden = isCancelButtonHidden
        
        titleLabel.text = title
        textView.text = text
        textView.scrollRangeToVisible(NSRange(location:0, length:0))
        okButton.setTitle(okButtonTitle, for: .normal)
        cancelButton.setTitle(cancelButtonTitle, for: .normal)
        textView.sizeToFit()
        textViewHeightConstraint.constant = textView.contentSize.height
        self.okAction = okAction
        self.cancelAction = cancelAction
    }
    
}
