//
//  SceneDelegate.swift
//  carWash
//
//  Created by Juliett Kuroyan on 15.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        try? window.addReachabilityObserver()
                    
        let configurator = LoginConfigurator()
        let vc = configurator.viewController
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.navigationBar.tintColor = .clear
        navigationController.interactivePopGestureRecognizer?.isEnabled = false
        navigationController.modalPresentationStyle = .fullScreen
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        let userDefaults = UserDefaults.standard
        if !userDefaults.bool(forKey: "hasRunBefore") {
            KeychainWrapper.standard.removeAllKeys()
            userDefaults.set(true, forKey: "hasRunBefore")
        }
        
        if let _ = KeychainWrapper.standard.data(forKey: "userToken")  {
            if let _ = connectionOptions.notificationResponse {
                KeychainWrapper.standard.set("", forKey: "notification")
            }
            navigationController.pushViewController(MainTabBarController(), animated: false)
            navigationController.navigationBar.isHidden = true
        }
        

        
    }
    
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

