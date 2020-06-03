//
//  UIViewController.swift
//  carWash
//
//  Created by Juliett Kuroyan on 25.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit

extension UIViewController {
    
    static var nibName: String {
        return String(describing: self)
    }
    
    func hideKeyboardWhenTapped() -> UITapGestureRecognizer {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        return tap
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showAlert(message: String, title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func showAlert(message: String,
                   title: String,
                   okButtonTitle: String,
                   cancelButtonTitle: String,
                   okAction: @escaping () -> (),
                   cancelAction: @escaping () -> ()) {
        
        let alert = UIAlertController(title: title,
                                             message: message,
                                             preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: okButtonTitle, style: .default, handler: { (action: UIAlertAction!) in
            okAction()
        }))

        alert.addAction(UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: { (action: UIAlertAction!) in
            cancelAction()
        }))

        present(alert, animated: true, completion: nil)
    }
    
    func showNetworkErrorMessage() {
        let window = UIApplication.shared.keyWindow!
        window.showMessageIfNotReachable()
    }
        
}

