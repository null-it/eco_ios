//
//  File.swift
//  carWash
//
//  Created by Juliett Kuroyan on 25.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit

@objc protocol NavigationBarConfigurationProtocol {
    @objc optional func backButtonPressed()
    @objc optional func exitButtonPressed()
    @objc optional func skipButtonPressed()
}


extension NavigationBarConfigurationProtocol where Self: UIViewController {

    
    func createBackButton() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 22))
        
        let backButton = UIButton(frame: CGRect(x: 0, y: 1, width: 12, height: 20))
        backButton.setImage(UIImage(named: "greenArrowBack"), for: .normal)
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(NavigationBarConfigurationProtocol.backButtonPressed), for: .touchUpInside)
        
        let label = UILabel(frame: CGRect(x: backButton.frame.maxX + 8, y: 0, width: 90, height: 22))
        label.font =  UIFont(name: "Gilroy-Regular", size: 16)
        view.addSubview(label)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NavigationBarConfigurationProtocol.backButtonPressed))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: view)
    }
    
    
    func createExitButton() {
        let exitButton: UIButton = UIButton(type: UIButton.ButtonType.custom)
        exitButton.setTitle("Выйти", for: .normal) // !
        exitButton.addTarget(self, action: #selector(NavigationBarConfigurationProtocol.exitButtonPressed), for: UIControl.Event.touchUpInside)
        exitButton.setTitleColor(UIColor(hex: "828282")!, for: .normal) // !
        exitButton.titleLabel?.font = UIFont(name: "Gilroy-Medium", size: 15)
        exitButton.frame = CGRect(x: 0, y: 0, width: 50, height: 20)
        let exitBarButton = UIBarButtonItem(customView: exitButton)
        navigationItem.rightBarButtonItem = exitBarButton
    }
    
    
    func createSkipButton() {
        
        let skipButton: UIButton = UIButton(type: UIButton.ButtonType.custom)
        skipButton.setTitle("Пропустить", for: .normal)  // !
        skipButton.addTarget(self, action: #selector(NavigationBarConfigurationProtocol.skipButtonPressed), for: UIControl.Event.touchUpInside)
        skipButton.setTitleColor(UIColor(hex: "828282")!, for: .normal) // !
        skipButton.titleLabel?.font = UIFont(name: "Gilroy-Medium", size: 15)
        skipButton.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        let skipBarButton = UIBarButtonItem(customView: skipButton)
        navigationItem.rightBarButtonItem = skipBarButton
    }
    
    
    
}

