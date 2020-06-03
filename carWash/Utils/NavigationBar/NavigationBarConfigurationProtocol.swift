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
    @objc optional func filterButtonPressed()
    @objc optional func exitButtonPressed()
    @objc optional func skipButtonPressed()
    //    @objc optional func cityButtonPressed()
    @objc optional func locationButtonPressed()
    @objc optional func closeButtonPressed()
    @objc optional func infoButtonPressed()
    @objc optional func clearButtonPressed()
}


extension NavigationBarConfigurationProtocol where Self: UIViewController {
    
    
    func createBackButton() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 22))
        
        let backButton = UIButton(frame: CGRect(x: 0, y: 1, width: 24, height: 24))
        backButton.setImage(UIImage(named: "greenArrowBack"), for: .normal)
        backButton.tag = 13
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(NavigationBarConfigurationProtocol.backButtonPressed), for: .touchUpInside)
        
        let label = UILabel(frame: CGRect(x: backButton.frame.maxX + 8, y: 0, width: 90, height: 22))
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        view.addSubview(label)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NavigationBarConfigurationProtocol.backButtonPressed))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: view)
    }
    
    
    func setBackButton(hidden: Bool) {
        if let view = navigationItem.leftBarButtonItem?.customView,
            let backButton = view.viewWithTag(13) as? UIButton {
            backButton.isHidden = hidden
        }
    }
    
    func createCloseButton() {
        let backButton = UIButton()
        backButton.setTitle("Закрыть", for: .normal)
        backButton.setTitleColor(Constants.green, for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        backButton.frame = CGRect(x: 0, y: 0, width: 70, height: 24)
        backButton.addTarget(self, action: #selector(NavigationBarConfigurationProtocol.closeButtonPressed), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backButton)
    }
    
    
    func createClearButton() {
        let skipButton: UIButton = UIButton(type: UIButton.ButtonType.custom)
        skipButton.setTitle("Сбросить", for: .normal)  // !
        skipButton.addTarget(self, action: #selector(NavigationBarConfigurationProtocol.clearButtonPressed), for: UIControl.Event.touchUpInside)
        skipButton.setTitleColor(Constants.green, for: .normal) // !
        skipButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        skipButton.frame = CGRect(x: 0, y: 0, width: 80, height: 24)
        let skipBarButton = UIBarButtonItem(customView: skipButton)
        navigationItem.rightBarButtonItem = skipBarButton
    }
    
    
    func createSkipButton() {
        let skipButton: UIButton = UIButton(type: UIButton.ButtonType.custom)
        skipButton.setTitle("Пропустить", for: .normal)  // !
        skipButton.addTarget(self, action: #selector(NavigationBarConfigurationProtocol.skipButtonPressed), for: UIControl.Event.touchUpInside)
        skipButton.setTitleColor(Constants.green, for: .normal) // !
        skipButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        skipButton.frame = CGRect(x: 0, y: 0, width: 100, height: 24)
        let skipBarButton = UIBarButtonItem(customView: skipButton)
        navigationItem.rightBarButtonItem = skipBarButton
    }
    
    
    func createLocationButton() {
        let locationButton: UIButton = UIButton(type: UIButton.ButtonType.custom)
        let image = UIImage(named: "locationMarker")
        locationButton.setImage(image, for: UIControl.State.normal)
        locationButton.addTarget(self, action: #selector(NavigationBarConfigurationProtocol.locationButtonPressed), for: UIControl.Event.touchUpInside)
        locationButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        locationButton.setNeedsLayout()
        let locationBarButton = UIBarButtonItem(customView: locationButton)
        if let _ = self.navigationItem.rightBarButtonItems {
            self.navigationItem.rightBarButtonItems!.append(locationBarButton)
        } else {
            self.navigationItem.rightBarButtonItems = [locationBarButton]
        }
    }
    
    
    func createExitButton() {
        let exitButton: UIButton = UIButton(type: UIButton.ButtonType.custom)
        let image = UIImage(named: "exitMarker")
        exitButton.setImage(image, for: UIControl.State.normal)
        exitButton.addTarget(self, action: #selector(NavigationBarConfigurationProtocol.exitButtonPressed), for: UIControl.Event.touchUpInside)
        exitButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        exitButton.setNeedsLayout()
        let exitBarButton = UIBarButtonItem(customView: exitButton)
        if let _ = self.navigationItem.rightBarButtonItems {
            self.navigationItem.rightBarButtonItems!.append(exitBarButton)
        } else {
            self.navigationItem.rightBarButtonItems = [exitBarButton]
        }
    }
    
    
    func createFilterButton() {
        let exitButton: UIButton = UIButton(type: UIButton.ButtonType.custom)
        let image = UIImage(named: "filter")
        exitButton.setImage(image, for: UIControl.State.normal)
        exitButton.addTarget(self, action: #selector(NavigationBarConfigurationProtocol.filterButtonPressed), for: UIControl.Event.touchUpInside)
        exitButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        exitButton.setNeedsLayout()
        let exitBarButton = UIBarButtonItem(customView: exitButton)
        if let _ = self.navigationItem.rightBarButtonItems {
            self.navigationItem.rightBarButtonItems!.append(exitBarButton)
        } else {
            self.navigationItem.rightBarButtonItems = [exitBarButton]
        }
    }
    
    
    func createInfoButton() {
          let infoButton: UIButton = UIButton(type: UIButton.ButtonType.custom)
          let image = UIImage(named: "info")
          infoButton.setImage(image, for: UIControl.State.normal)
          infoButton.addTarget(self, action: #selector(NavigationBarConfigurationProtocol.infoButtonPressed), for: UIControl.Event.touchUpInside)
          infoButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
          infoButton.setNeedsLayout()
          let infoBarButton = UIBarButtonItem(customView: infoButton)
          if let _ = self.navigationItem.rightBarButtonItems {
              self.navigationItem.rightBarButtonItems!.append(infoBarButton)
          } else {
              self.navigationItem.rightBarButtonItems = [infoBarButton]
          }
      }
}

