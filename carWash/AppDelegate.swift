//
//  AppDelegate.swift
//  carWash
//
//  Created by Juliett Kuroyan on 15.11.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let gcmMessageIDKey = "gcm.message_id"
    let typeKey = "type"
    let washKey = "wash"
    let priceKey = "value"
    let operationIDKey = "operation_id"
    let stockIDKey = "stock_id"

    var reviewNotificationResponse: ReviewNotificationResponse?
    var stockNotificationResponse: SaleNotificationResponse?
    var didRecieveReviewNotificationResponse: (()->())?
    var didRecieveSaleNotificationResponse: ((SaleNotificationResponse)->())?
    
    private var application: UIApplication?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.application = application
        
//        UILabel.appearance().font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle(rawValue: "SanFrancisco"))

        if (launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] != nil) {
            // !
            KeychainWrapper.standard.set("", forKey: "notification")
        }
        
        if #available(iOS 13.0, *) {
            // In iOS 13 setup is done in SceneDelegate
        } else {
            window = UIWindow(frame: UIScreen.main.bounds)
            try? window?.addReachabilityObserver()
            let configurator = LoginConfigurator()
            let vc = configurator.viewController
            let navigationController = UINavigationController(rootViewController: vc)
            navigationController.navigationBar.tintColor = .clear
            navigationController.interactivePopGestureRecognizer?.isEnabled = false
            navigationController.modalPresentationStyle = .fullScreen
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
            
            let userDefaults = UserDefaults.standard
            if !userDefaults.bool(forKey: "hasRunBefore") {
                KeychainWrapper.standard.removeAllKeys()
                userDefaults.set(true, forKey: "hasRunBefore")
            }
            
            if let _ = KeychainWrapper.standard.data(forKey: "userToken")  {
                navigationController.pushViewController(MainTabBarController(), animated: false)
                navigationController.navigationBar.isHidden = true
            }
        }
       
        if let _ = KeychainWrapper.standard.data(forKey: "userToken")  {
            configureFirebase()
        }
        

        
        
        return true
    }
    
    func configureFirebase() {
        guard let application = self.application,
            FirebaseApp.app() == nil else {
                if let token = Messaging.messaging().fcmToken {
                    sendToken(token: token)
                }
                return
        }
        
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        application.registerForRemoteNotifications()
    }
    
    // MARK: UISceneSession Lifecycle
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
        self.window?.removeReachabilityObserver()
    }
    
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
         Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
         Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }

}


extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: NSNotification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
        UserDefaults.standard.set(fcmToken, forKey: "fcmToken")
        sendToken(token: fcmToken)
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Messsage Data ", remoteMessage.appData)
    }

    
    private func sendToken(token: String) {
        let request = Request.User.SetFirebaseToken.Post(token: token)
        request.send().done { _ in
            () // !
        }.catch { error in
            print(error) // !
        }
    }
}


extension AppDelegate : UNUserNotificationCenterDelegate {
    
func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let content = notification.request.content
        let userInfo = content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        
        
//        if let badge = content.badge {
//            UIApplication.shared.applicationIconBadgeNumber = badge.intValue
//            self.badgeValue.value = badge.intValue
//            setBadges?(badge.intValue)
//        }
//        completionHandler([.alert, .badge])
        completionHandler([.alert])

    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let type = userInfo[typeKey] as? String {
            switch type {
            case "review":
                if let price = userInfo[priceKey] as? String,
                    let washJson = userInfo[washKey] as? String,
                    let operationIdStr = userInfo[operationIDKey] as? String,
                    let operationId = Int(operationIdStr),
                    let jsonData = washJson.data(using: .utf8),
                    let wash = try? JSONDecoder().decode(WashResponse.self, from: jsonData) {
                    var rub = price
                    rub.removeLast(2)
                    rub += " ₽"
                    reviewNotificationResponse = ReviewNotificationResponse(price: rub,
                                                                            type: type,
                                                                            wash: wash,
                                                                            operationId: operationId)
                    didRecieveReviewNotificationResponse?()
                }
            case "stock":
                if let saleIdStr = userInfo[stockIDKey] as? String,
                    let saleId = Int(saleIdStr) {
                    stockNotificationResponse = SaleNotificationResponse(id: saleId)
                    didRecieveSaleNotificationResponse?(stockNotificationResponse!)
                    notificationViewed(stockId: saleId)
                }
            default:
                ()
            }
            
            
//            let application = UIApplication.shared
//
//            if(application.applicationState == .active){
//              print("user tapped the notification bar when the app is in foreground")
//            }
//
//            if(application.applicationState == .inactive) {
//              print("user tapped the notification bar when the app is in background")
//            }
        }
        
        completionHandler()
    }
    
    
    private func notificationViewed(stockId: Int) {
        let request = Request.User.SetStockViewed.Post(stockId: stockId)
        request.send().done { _ in
            ()
        }.catch { error in
            print(error)
        }
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        print("userNotificationCenter")
    }
}
