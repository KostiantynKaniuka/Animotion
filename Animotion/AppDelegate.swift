//
//  AppDelegate.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 25.05.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granded, error in
            if (!granded) {
                print("Denied")
            }
        }
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if let badgeNumber = notification.request.content.badge as? Int {
            UIApplication.shared.applicationIconBadgeNumber = badgeNumber
        }
        completionHandler([.banner, .sound, .badge])
    }
}
