//
//  MainTabBar.swift
//  carWash
//
//  Created by Juliett Kuroyan on 19.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    lazy var profileVC: UIViewController = {
        configureProfile()
    }()
    
    lazy var salesVC: UIViewController = {
        configureSales()
    }()
    
    lazy var mapVC: UIViewController = {
        configureMap()
    }()


    private let tabBarItems: [UITabBarItem] = [
        UITabBarItem(title: "Акции", image: UIImage(named: "sales"), selectedImage: nil),
        UITabBarItem(title: "Профиль", image: UIImage(named: "profile"), selectedImage: nil),
        UITabBarItem(title: "Карта", image: UIImage(named: "map"), selectedImage: nil),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let views = [profileVC, salesVC, mapVC]
        self.viewControllers = views
        tabBar.tintColor = UIColor(hex: "27AE60")
        setRoundedCorners()
    }
    
    
    func setRoundedCorners() {
        let cornerRadius: CGFloat = 28
        tabBar.layer.masksToBounds = true
        tabBar.layer.cornerRadius = cornerRadius
    }
    
    
    private func configureMap() -> UIViewController {
        let configurator = MapConfigurator()
        let vc = configurator.viewController
        vc.tabBarItem = tabBarItems[2]
        let navigationController = configureNavigationController(vc: vc, title: "Мойки в городе")
        return navigationController
    }
    
    
    private func configureProfile() -> UIViewController {
        let configurator = MainConfigurator()
        let vc = configurator.viewController
        vc.tabBarItem = tabBarItems[1]
        let navigationController = configureNavigationController(vc: vc, title: "Профиль")
        return navigationController
    }
    
    
    private func configureSales() -> UIViewController {
        let vc = UIViewController() // !
        vc.tabBarItem = tabBarItems[0]
        let navigationController = configureNavigationController(vc: vc, title: "Акции")
        return navigationController
    }
    
    
    private func configureNavigationController(vc: UIViewController,
                                               title: String) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.navigationBar.topItem?.title = title
        navigationController.navigationBar.titleTextAttributes =
            [ NSAttributedString.Key.font: UIFont(name: "Gilroy-Medium", size: 18)!]
        navigationController.modalPresentationStyle = .fullScreen
        return navigationController
    }
    
}

