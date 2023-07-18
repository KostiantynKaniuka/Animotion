//
//  LoginViewController.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 10.07.2023.
//

import UIKit
import Combine
import SnapKit

protocol LoginViewControllerDelegate: AnyObject {
    func didLogin()
}

final class LoginViewController: UIViewController {
    private let backgroundImage = UIImageView()
    private let emailTextField = CustomTextField()
    private let passwordTextField = CustomTextField()
    private let textFieldStack = UIStackView()
    private let loginButtonsStack = UIStackView()
    private let createAccountStack = UIStackView()
    private let createAccountLabel = UILabel()
    private let logInButton = LoginButton()
    private let forgotPasswordBurron = ForgotPassButton()
    private let dontHaveAccoutButton = DontHaveAccountButton()
    private let loginVM = LoginViewModel()
    weak var loginDelegate: LoginViewControllerDelegate?
    
    private var signinValidationPublishers: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest(loginVM.passwordText, loginVM.emailText)
            .map {  passwordText, emailText in
                !passwordText.isEmpty && !emailText.isEmpty
            }
            .eraseToAnyPublisher()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        logInButton.addTarget(self, action: #selector(sigInButtonTapped), for: .touchUpInside)
        
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.addTarget(self, action: #selector(emailTextFiledTapped), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passTextFiledTapped), for: .editingChanged)
        dontHaveAccoutButton.addTarget(self, action: #selector(dontHaveAccountButtonTapped), for: .touchUpInside)
        
        signinValidationPublishers
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: logInButton)
            .store(in: &loginVM.subscriptions)
        
        setupAppearance()
        setUpConstraints()
    }
      
    @objc private func sigInButtonTapped() {
        loginDelegate?.didLogin()
    }
    
    @objc private func emailTextFiledTapped () {
        loginVM.emailText.value = emailTextField.text ?? ""
     
    }
    
    @objc private func passTextFiledTapped () {
        loginVM.passwordText.value = passwordTextField.text ?? ""
    }
    
    @objc private func dontHaveAccountButtonTapped() {
        let registrationVC = RegistrationViewController()
        self.present(registrationVC, animated: true)
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

extension LoginViewController {
    
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
    
    func setupAppearance() {
        backgroundImage.image = UIImage(named: "backtest")
        createAccountLabel.text = "Don't  have an account?"
        createAccountLabel.textColor = .darkGray
        createAccountLabel.font = .systemFont(ofSize: 15)
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        emailTextField.keyboardType = .emailAddress
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        passwordTextField.isSecureTextEntry = true
    }
}
