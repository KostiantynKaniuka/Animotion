//
//  InitialViewController.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 20.07.2023.
//

import UIKit
import Combine
import SnapKit
import FirebaseAuth

protocol AuthNavigationToMainDelegate: AnyObject {
    func navigateToMain()
}

protocol AuthNavigationToLogin: AnyObject {
    func navigateToLigin()
}

final class InitialViewController: UIViewController {
    private let backgroundImage = UIImageView()
    private let logoImage = UIImageView()
    private let progressBar = UIProgressView()
    private let authStateVM = AuthStateViewModel()
    weak var navigationToMainDelegate: AuthNavigationToMainDelegate?
    weak var navigationToLoginDelegate: AuthNavigationToLogin?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAperance()
        setUpConstraints()
        guideUser()
    }
    
    private func guideUser() {
         authStateVM.authenticationState
             .sink { [weak self] state in
                 switch state {
                 case .unauthenticated:
                     print("unauthenticated")
                     DispatchQueue.main.async {
                         self?.navigationToLoginDelegate?.navigateToLigin()
                     }
                 case .authenticating:
                     print("checking the user state")
                 case .authenticated:
                     DispatchQueue.main.async {
                         self?.navigationToMainDelegate?.navigateToMain()
                     }
                 }
             }
             .store(in: &authStateVM.bag)
     }
    
    deinit {
        print("➡️Initial gone")
    }
 }

extension InitialViewController {
    
    private func setUpConstraints() {
        view.add(subviews: backgroundImage, logoImage)
        
        backgroundImage.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom)
            make.top.equalTo(view.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
        }
    
        logoImage.snp.makeConstraints { make in
           
              if UIScreen.main.bounds.size.height >= 812 { // iPhone X and newer models
                  make.top.equalTo(view.snp.top).offset(120)
              } else { // iPhone 8 and older models
                  make.top.equalTo(view.snp.top).offset(50)
              }
            make.centerX.equalTo(view.snp.centerX)
            make.size.equalTo(CGSize(width: 150, height: 150))
        }
        
    }
    
    
    private func setUpAperance() {
        logoImage.image = UIImage(named: "AppIcon")
        logoImage.layer.cornerRadius = 20
        logoImage.layer.masksToBounds = false
        logoImage.clipsToBounds = true
        backgroundImage.image = UIImage(named: "backblacktest")
        
        
    }
}
