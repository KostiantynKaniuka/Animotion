//
//  ContainerViewController.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 26.05.2023.
//

import UIKit

class ContainerViewController: UIViewController {
    private let menuVC = MenuViewController()
    private let mainScreen = MainViewController()
    private var menuState: MenuState = .open
    var navVC: UINavigationController?
    

    override func viewDidLoad() {
        super.viewDidLoad()
addChild()
      
    }
    
    private func addChild() {
        //SideMenu
        addChild(menuVC)
        view.addSubview(menuVC.view)
        menuVC.didMove(toParent: self)
        
        //HomeVC
        mainScreen.delegate = self
        let navigationController = UINavigationController(rootViewController: mainScreen)
        navVC = navigationController
        addChild(navigationController)
        view.addSubview(navigationController.view)
        navigationController.didMove(toParent: self)
      
    }
}

extension ContainerViewController: MainViewControllerDelegate {
    func didTapMoodButton() {
        switch menuState {
        case .close:
            // open it
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                self.mainScreen.view.frame.origin.x =  self.mainScreen.view.frame.size.width - 100
            } completion: {[weak self] done in
                if done {
                    self?.menuState = .open
                }
            }
        case .open:
            //close it
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                self.mainScreen.view.frame.origin.x =  0
            } completion: {[weak self] done in
                if done {
                    self?.menuState = .close
                }
            }
            break
        }
    }
    
    
}
