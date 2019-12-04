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
        UITabBarItem(title: nil, image: UIImage(named: "sales"), selectedImage: nil),
        UITabBarItem(title: nil, image: UIImage(named: "profile"), selectedImage: nil),
        UITabBarItem(title: nil, image: UIImage(named: "map"), selectedImage: nil),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let views = [profileVC, salesVC, mapVC]
        self.viewControllers = views
        tabBar.tintColor = UIColor(hex: "27AE60") // !
        tabBar.items?.forEach({ (item) in
            item.imageInsets.top = 6 // !
            item.imageInsets.bottom = -6 // !
        })
        setRoundedCorners()
    }
    
    
    func setRoundedCorners() {
        let cornerRadius: CGFloat = 28 // !        
        if #available(iOS 13.0, *) {
            let appearance = tabBar.standardAppearance.copy()
            appearance.configureWithTransparentBackground()
            appearance.backgroundImage = UIImage(named: "tabBarBackgrpund")
            tabBar.standardAppearance = appearance
        } else {
            tabBar.backgroundColor = .clear
//            let image = UIImage(ciImage: CIImage(color: CIColor.clear)).af_imageAspectScaled(toFit: tabBar.bounds.size)
            tabBar.backgroundImage = UIImage(named: "tabBarBackgrpund")
            tabBar.shadowImage = UIImage()
        }
        
        tabBar.layer.masksToBounds = false
        tabBar.layer.cornerRadius = cornerRadius
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowPath = UIBezierPath(roundedRect: tabBar.bounds, cornerRadius: cornerRadius).cgPath
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 3)
        tabBar.layer.shadowOpacity = 0.2
        tabBar.layer.shadowRadius = 10
    }
    
    
    private func configureMap() -> UIViewController {
        let configurator = MapConfigurator(isAuthorized: true)
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
        let configurator = SalesConfigurator()
        let vc = configurator.viewController
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
        navigationController.navigationBar.barTintColor = .white
        return navigationController
    }
    
}

