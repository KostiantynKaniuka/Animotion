//
//  AppDelegate.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 25.05.2023.
//

import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
    
        return true
    }
}
