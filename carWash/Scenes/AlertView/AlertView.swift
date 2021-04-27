//
//  AlertView.swift
//  carWash
//
//  Created by Juliett Kuroyan on 11.02.2020.
//  Copyright © 2020 VooDooLab. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class AlertView: UIView {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var topAlertConstraint: NSLayoutConstraint!
    @IBOutlet weak var centerYConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var promocodeMessageLabel: UILabel!
    @IBOutlet weak var promocodeField: UITextField!
    // MARK: - Properties
    
    private var okAction: (()->())? = nil
    private var cancelAction: (()->())? = nil

    private var isForPromocode: Bool = false
    
    // MARK: - Actions
    
    @IBAction func okButtonPressed(_ sender: Any) {
        okAction?()
        if !isForPromocode {
            removeFromSuperview()
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        cancelAction?()
        removeFromSuperview()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        promocodeField.delegate = self
        promocodeField.isHidden = true
        promocodeMessageLabel.isHidden = true
    }
    
    // MARK: - Public
    
    func set(title: String,
             text: String,
             okAction: (()->())? = nil,
             cancelAction: (()->())? = nil,
             okButtonTitle: String,
             cancelButtonTitle: String,
             isForPromocode: Bool = false) {
        
        self.isForPromocode = isForPromocode
        
        let isCancelButtonHidden = cancelAction == nil
        cancelButton.isHidden = isCancelButtonHidden
        separatorView.isHidden = isCancelButtonHidden
        
        titleLabel.text = title
        textView.text = text
        
        okButton.setTitle(okButtonTitle, for: .normal)
        cancelButton.setTitle(cancelButtonTitle, for: .normal)
        textView.isScrollEnabled = false
        self.okAction = okAction
        self.cancelAction = cancelAction
        
        if isForPromocode {
            textView.isHidden = true
            promocodeMessageLabel.isHidden = false
            promocodeField.isHidden = false
            okButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        }
    }
    
}


extension AlertView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.topAlertConstraint.priority = UILayoutPriority(1000)
            self.centerYConstraint.priority = UILayoutPriority(750)
            self.heightConstraint.priority = UILayoutPriority(1000)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            self.topAlertConstraint.priority = UILayoutPriority(750)
            self.centerYConstraint.priority = UILayoutPriority(1000)
            self.heightConstraint.priority = UILayoutPriority(750)
        }
    }
    
}
