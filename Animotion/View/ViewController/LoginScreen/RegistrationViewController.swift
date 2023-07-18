//
//  RegistrationViewController.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 18.07.2023.
//

import UIKit
import SnapKit
import Combine

final class RegistrationViewController: UIViewController {
    private let backgroundImage = UIImageView()
    private let textFieldStack = UIStackView()
    private let nameTextField = CustomTextField()
    private let emailTextField = CustomTextField()
    private let passwordTextField = CustomTextField()
    private let repeatPasswordTextField = CustomTextField()
    private let createAccButton = CreateAccountButton()
    private let registationVM = RegistrationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpConstraints()
        setUpAppearance()
        
    }
    
    
    
    
    private func setUpConstraints() {
        textFieldStack.spacing = 20
        textFieldStack.alignment = .center
        textFieldStack.axis = .vertical
        textFieldStack.distribution = .fillProportionally
        
        view.addSubview(backgroundImage)
        view.addSubview(textFieldStack)
        textFieldStack.addArrangedSubview(nameTextField)
        textFieldStack.addArrangedSubview(emailTextField)
        textFieldStack.addArrangedSubview(passwordTextField)
        textFieldStack.addArrangedSubview(repeatPasswordTextField)
        textFieldStack.addArrangedSubview(createAccButton)
        
        backgroundImage.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom)
            make.top.equalTo(view.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
        }
        
        textFieldStack.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
        }
       
        nameTextField.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 300, height: 40))
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 300, height: 40))
        }
        
        repeatPasswordTextField.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 300, height: 40))
        }
        emailTextField.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 300, height: 40))
        }
        
        createAccButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 100, height: 40))
        }
        
    }
    
    private func setUpAppearance() {
        backgroundImage.image = UIImage(named: "backtest")
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Enter your name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        emailTextField.keyboardType = .emailAddress
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        passwordTextField.isSecureTextEntry = true
        
        repeatPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Repeat password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        repeatPasswordTextField.isSecureTextEntry = true
        
        
    }
    
    deinit {
        print("➡️ registration gone")
    }

}
