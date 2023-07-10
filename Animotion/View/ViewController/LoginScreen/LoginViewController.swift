//
//  LoginViewController.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 10.07.2023.
//

import UIKit
import SnapKit

final class LoginViewController: UIViewController {
    private let backgroundImage = UIImageView()
    private let emailTextField = LoginTextfiel()
    private let passwordTextField = LoginTextfiel()
    private let textFieldStack = UIStackView()
    private let loginButtonsStack = UIStackView()
    private let createAccountStack = UIStackView()
    private let createAccountLabel = UILabel()
    private let logInButton = LoginButton()
    private let forgotPasswordBurron = ForgotPassButton()
    private let dontHaveAccoutButton = DontHaveAccountButton()
    private var navigation: LoginNavigation = .failure
    private var nextVC = UIViewController()
    let navVc = UINavigationController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        logInButton.addTarget(self, action: #selector(sigInButtonTapped), for: .touchUpInside)
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        
        setupAperance()
        setUpConstraints()
    }
    
    
    func presentNextState() {
        navVc.setViewControllers([nextVC], animated: true)
        view.add(subviews: navVc.view)
        addChild(navVc)
        navVc.didMove(toParent: self)
        
        
    }
    
    @objc private func sigInButtonTapped() {
        navigation = .logedin
        switch navigation {
            
        case .logedin:
            nextVC = MainViewController()
        case .failure:
            nextVC = self
        }
        presentNextState()
        
    }
   
    

    private func setUpConstraints() {
        createAccountStack.alignment = .fill
        createAccountStack.axis = .horizontal
        createAccountStack.distribution = .fill
        
        loginButtonsStack.spacing = 15
        loginButtonsStack.alignment = .fill
        loginButtonsStack.axis = .vertical
        loginButtonsStack.distribution = .fill
        
    
        textFieldStack.spacing = 20
        textFieldStack.alignment = .fill
        textFieldStack.axis = .vertical
        textFieldStack.distribution = .fill
        
        view.add(subviews: backgroundImage,textFieldStack, createAccountStack)
        
        backgroundImage.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom)
            make.top.equalTo(view.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
        }
        
        createAccountStack.addArrangedSubview(createAccountLabel)
        createAccountStack.addArrangedSubview(dontHaveAccoutButton)
        
        textFieldStack.addArrangedSubview(emailTextField)
        textFieldStack.addArrangedSubview(passwordTextField)
        
        loginButtonsStack.addArrangedSubview(forgotPasswordBurron)
        loginButtonsStack.addArrangedSubview(logInButton)
        
        textFieldStack.addArrangedSubview(loginButtonsStack)
        
        createAccountStack.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(view.safeAreaInsets.bottom).offset(-24)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 300, height: 40))
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 300, height: 40))
        }
        
        logInButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 300, height: 40))
        }
        
        textFieldStack.snp.makeConstraints { make in
            make.center.equalTo(view.center)
        }
    }
    
    func setupAperance() {
        backgroundImage.image = UIImage(named: "backtest")
        createAccountLabel.text = "Don't  have an account?"
        createAccountLabel.textColor = .darkGray
        createAccountLabel.font = .systemFont(ofSize: 15)
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        emailTextField.keyboardType = .emailAddress
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        passwordTextField.isSecureTextEntry = true
    }
    
    deinit {
        print("➡️ login gone")
    }
}

extension LoginViewController: UITextFieldDelegate {
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
       }
    
    
}
