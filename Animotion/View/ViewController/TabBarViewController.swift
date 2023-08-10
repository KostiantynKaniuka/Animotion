//
//  TabBarViewController.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 10.08.2023.
//

import UIKit

final class TabBarViewController: UITabBarController {
    var homeVC: UIViewController?
    var userVC: UIViewController?
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        let home = self.createNav(with: "Home", and: UIImage(systemName: "house"), vc: homeVC ?? UIViewController())
        self.setViewControllers([], animated: false)
        let user = self.createNav(with: "User", and: UIImage(systemName: "person.circle"), vc: userVC ?? UIViewController())
        self.setViewControllers([home, user], animated: false)
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
