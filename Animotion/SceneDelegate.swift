//
//  SceneDelegate.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 25.05.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
          let window = UIWindow(windowScene: windowScene)
          window.rootViewController = MainViewController() // Where ViewController() is the initial View Controller
          window.makeKeyAndVisible()
          self.window = window
        guard let _ = (scene as? UIWindowScene) else { return }
    }
}
