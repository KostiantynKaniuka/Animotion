//
//  TabBarViewController.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 10.08.2023.
//

import UIKit

final class TabBarViewController: UITabBarController {
    //var homeVC = MainViewController()
    var userVC = UserScreenViewController()
    var captureVC = CaptureViewController()
    var mainVC = MainViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captureVC.graphDelegate = mainVC.chartView
        captureVC.radarDelegate = userVC
        mainVC.submitDelegate = captureVC
        captureVC.timerDelegate = mainVC
        setTabBar()
    }
    
    func setTabBar() {
        let home = self.createNav(with: "Home", and: UIImage(systemName: "house"), vc: mainVC)
        let user = self.createNav(with: "User", and: UIImage(systemName: "person.circle"), vc: userVC )
        let capture = self.createNav(with: "Capture", and:  UIImage(systemName: "camera.filters"), vc: captureVC)
        self.setViewControllers([home, capture, user], animated: false)
        
        setUpTabBarColors()
    }
    
    private func createNav(with title: String, and image: UIImage? , vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        return nav
    }
    
    private func setUpTabBarColors() {
        self.tabBar.backgroundColor = .barBackground
        self.tabBar.tintColor = .white
        self.tabBar.unselectedItemTintColor = .black
    }
}
