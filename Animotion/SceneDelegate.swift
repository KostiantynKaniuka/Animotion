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
        let initialVC = InitialViewController()
        initialVC.navigationToMainDelegate = self
        initialVC.navigationToLoginDelegate = self
        window.rootViewController = initialVC
        window.makeKeyAndVisible()
        self.window = window
        guard let _ = (scene as? UIWindowScene) else { return }
        }
    }


//MARK: - Login action
extension SceneDelegate: LoginViewControllerDelegate {
    
    func didLogin() {
        let mainVc = TabBarViewController()
        mainVc.userVC.logoutDelegate = self
        setRootViewController(mainVc)
    }
}

//MARK: - LogOutn action
extension SceneDelegate: LogoutDelegate {
    
    func didLogout() {
        let newSessionVc = LoginViewController()
        newSessionVc.loginDelegate = self
     setRootViewController(newSessionVc)
    }
}

//MARK: - Logout action
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

//MARK: - Checking user authstate for navigation
extension SceneDelegate: AuthNavigationToLogin {
    func navigateToLogin() {
        let vc = LoginViewController()
        vc.loginDelegate = self
        setRootViewController(vc)
    }
}

extension SceneDelegate: AuthNavigationToMainDelegate {
    func navigateToMain() {
        let  vc = TabBarViewController()
        vc.userVC.logoutDelegate = self
        setRootViewController(vc)
    }
}
