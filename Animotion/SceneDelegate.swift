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
        let loginVC = LoginViewController()
        loginVC.loginDelegate = self
        window.rootViewController = loginVC
        window.makeKeyAndVisible()
        self.window = window
        guard let _ = (scene as? UIWindowScene) else { return }
    }
}

extension SceneDelegate: LoginViewControllerDelegate {
    func didLogin() {
        let mainVc = MainViewController()
        mainVc.userVCDelegate = self
         let navVc = UINavigationController(rootViewController: mainVc)
        setRootViewController(navVc)
    }
}

extension SceneDelegate: LogoutDelegate {
    func didLogout() {
        
        let newSessionVc = LoginViewController()
        newSessionVc.loginDelegate = self
     setRootViewController(newSessionVc)
    }
}

extension SceneDelegate {
    func setRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard animated, let window = self.window else {
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
            return
        }
        
        window.rootViewController = vc
        window.makeKeyAndVisible()
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
    }
}

extension SceneDelegate: PassUserViewController {
    var userViewConltoller: UIViewController {
        get {
            let vc = UserScreenViewController()
            vc.logoutDelegate = self
            return vc
        }
    }
}
