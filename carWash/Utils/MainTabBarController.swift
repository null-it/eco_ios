//
//  MainTabBar.swift
//  carWash
//
//  Created by Juliett Kuroyan on 19.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

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
    
    lazy var qrVC: UIViewController = {
        configureQR()
    }()


    private let tabBarItems: [UITabBarItem] = [
        UITabBarItem(title: nil, image: UIImage(named: "sales"), selectedImage: nil),
        UITabBarItem(title: nil, image: UIImage(named: "profile"), selectedImage: nil),
        UITabBarItem(title: nil, image: UIImage(named: "map"), selectedImage: nil),
        UITabBarItem(title: nil, image: UIImage(named: "qr"), selectedImage: nil)
    ]
    
    // !
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.didRecieveSaleNotificationResponse = { [weak self] (saleNotificationResponse) in
            guard let self = self else { return }
            if let navigation = self.salesVC as? UINavigationController,
                let vc = navigation.viewControllers.first as? SalesViewController {
                self.selectedIndex = 1 //
                vc.presentSaleInfoView(id: saleNotificationResponse.id)
            }
        }
        
        
        if let _ = KeychainWrapper.standard.string(forKey: "notification"),
            let notificationResponse = appDelegate.stockNotificationResponse {
            appDelegate.didRecieveSaleNotificationResponse?(notificationResponse)
            KeychainWrapper.standard.removeObject(forKey: "notification")
        }
        
        let views = [profileVC, salesVC, mapVC, qrVC]
        self.viewControllers = views
        tabBar.tintColor = Constants.green
        tabBar.items?.forEach({ (item) in
            item.imageInsets.top = 6 // !
            item.imageInsets.bottom = -6 // !
        })
    }
    
    override func viewDidLayoutSubviews() {
        setRoundedCorners()
    }
    
    func setRoundedCorners() {
        let cornerRadius: CGFloat = 28 // !
        view.backgroundColor = .white
        tabBar.backgroundImage = UIImage.from(color: .clear)
        tabBar.shadowImage = UIImage()
        
        let tabbarBackgroundView = RoundShadowView(frame: tabBar.frame)
        tabbarBackgroundView.cornerRadius = cornerRadius
        tabbarBackgroundView.layer.masksToBounds = false
        tabbarBackgroundView.backgroundColor = .white
        tabbarBackgroundView.frame = tabBar.frame
        view.addSubview(tabbarBackgroundView)
        
        let fillerView = UIView()
        fillerView.frame = tabBar.frame
        fillerView.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: cornerRadius)
        fillerView.backgroundColor = .white
        view.addSubview(fillerView)
        
        view.bringSubviewToFront(tabBar)
        //        if #available(iOS 15.0, *) {
        //            let appearance = UITabBarAppearance()
//            appearance.configureWithOpaqueBackground()
//            appearance.backgroundImage = UIImage(named: "tabBarBackgrpund")
//            tabBar.standardAppearance = appearance
//            tabBar.scrollEdgeAppearance = appearance
//        } else if #available(iOS 13.0, *) {
//            let appearance = tabBar.standardAppearance.copy()
//            appearance.configureWithTransparentBackground()
//            appearance.backgroundImage = UIImage(named: "tabBarBackgrpund")
//            tabBar.standardAppearance = appearance
//        } else {
//            tabBar.backgroundColor = .clear
////            let image = UIImage(ciImage: CIImage(color: CIColor.clear)).af_imageAspectScaled(toFit: tabBar.bounds.size)
//            tabBar.backgroundImage = UIImage(named: "tabBarBackgrpund")
//            tabBar.shadowImage = UIImage()
//        }
//
//        tabBar.layer.masksToBounds = false
//        tabBar.layer.cornerRadius = cornerRadius
//        tabBar.layer.shadowColor = UIColor.black.cgColor
//        let window = UIApplication.shared.keyWindow!
//        let bounds = CGRect(x: 0, y: 0, width: window.frame.width, height: tabBar.frame.height)
//        tabBar.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
//        tabBar.layer.shadowOffset = CGSize(width: 0, height: 3)
//        tabBar.layer.shadowOpacity = 0.2
//        tabBar.layer.shadowRadius = 10
    }
    
    
    private func configureQR() -> UIViewController {
        let configurator = WashingStartConfigurator()
        let vc = configurator.viewController
        vc.tabBarItem = tabBarItems[3]
        let navigationController = configureNavigationController(vc: vc, title: "Начать мойку")
        return navigationController
    }
    
    
    private func configureMap() -> UIViewController {
        let configurator = MapConfigurator(isAuthorized: true, washId: nil, tabBarController: self, isWashingStart: false)
        let vc = configurator.viewController
        vc.tabBarItem = tabBarItems[2]
        let navigationController = configureNavigationController(vc: vc, title: "Мойки в городе")
        return navigationController
    }
    
    
    private func configureProfile() -> UIViewController {
        let configurator = MainConfigurator(tabBarController: self)
        let vc = configurator.viewController
        vc.tabBarItem = tabBarItems[1]
        let navigationController = configureNavigationController(vc: vc, title: "Профиль")
        return navigationController
    }
    
    
    private func configureSales() -> UIViewController {
        let configurator = SalesConfigurator(tabBarController: self)
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
            [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .semibold)]
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.navigationBar.barTintColor = .white
        return navigationController
        
    }
    
}


extension UIImage {
    static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}


class RoundShadowView: UIView {

    let containerView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func layoutView() {

        // set the shadow of the view's layer
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 10.0
        containerView.layer.cornerRadius = cornerRadius
        containerView.layer.masksToBounds = false

        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false

        // pin the containerView to the edges to the view
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
