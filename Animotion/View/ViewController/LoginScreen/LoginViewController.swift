//
//  LoginViewController.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 10.07.2023.
//

import UIKit
import Combine
import CombineCocoa
import SnapKit
import FirebaseAuth

protocol LoginViewControllerDelegate: AnyObject {
    func didLogin()
}

final class LoginViewController: UIViewController {
    private let logoImage = UIImageView()
    private let backgroundImage = UIImageView()
    private let emailTextField = CustomTextField()
    private let passwordTextField = PasswordTextField()
    private let textFieldStack = UIStackView()
    private let loginButtonsStack = UIStackView()
    private let createAccountStack = UIStackView()
    private let createAccountLabel = UILabel()
    private let logInButton = LoginButton()
    private let forgotPasswordBurron = ForgotPassButton()
    private let dontHaveAccoutButton = DontHaveAccountButton()
    private let loginVM = LoginViewModel()
    weak var loginDelegate: LoginViewControllerDelegate?
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        logInButton.addTarget(self, action: #selector(sigInButtonTapped), for: .touchUpInside)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        bindTextField()
        dontHaveAccoutButtonTapped()
        
    }
    
    private func bindTextField() {
        passwordTextField.textPublisher
            .compactMap({$0})
            .sink { [weak self] text in
                guard let self = self else {return}
                self.loginVM.passwordText.value = text
            }
            .store(in: &loginVM.subscriptions)
        
        emailTextField.textPublisher
            .compactMap({$0})
            .sink { [weak self] text in
                guard let self = self else {return}
                self.loginVM.emailText.value = text
            }
            .store(in: &loginVM.subscriptions)
        
        loginVM.signinValidationPublishers
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: logInButton)
            .store(in: &loginVM.subscriptions)
    }
    
    private func dontHaveAccoutButtonTapped() {
        dontHaveAccoutButton.tapPublisher
            .sink { [weak self] _ in
                guard let self = self else {return}
                let registrationVC = RegistrationViewController()
                registrationVC.modalPresentationStyle = .fullScreen
                self.present(registrationVC, animated: true)
            }
            .store(in: &loginVM.subscriptions)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layoutIfNeeded() // fixing buttons stackview
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setUpConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupAppearance()
    }
      
    @objc private func sigInButtonTapped() {
       // loginDelegate?.didLogin()
        Auth.auth().signIn(withEmail: loginVM.emailText.value,
                           password: loginVM.passwordText.value) { [weak self]  authResut, error in
            guard let self = self else {return}
            if let error = error as NSError? {
                let message  = self.loginVM.formateAuthError(error)
                self.loginVM.showAlert(message: message, vc: self)
            }
            if authResut != nil {
                let user = Auth.auth().currentUser
                guard let currentUser = user else {return}
                if currentUser.isEmailVerified {
                    self.loginDelegate?.didLogin()
                }
                else {
                    self.loginVM.showAlert(message: "Please verify your email", vc: self)
                }
            }

        }
    }
    
    deinit {
        print("➡️ login gone")
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text ?? ""
        let updatedText = (text as NSString).replacingCharacters(in: range, with: string)
        
        if updatedText.count > 42 || string.contains(" ") {
            return false
        } else {
            return true
        }
       }
}

extension LoginViewController {
    
    private func setUpConstraints() {
        createAccountStack.alignment = .center
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
        createAccountStack.addArrangedSubview(createAccountLabel)
        createAccountStack.addArrangedSubview(dontHaveAccoutButton)
        
        textFieldStack.addArrangedSubview(emailTextField)
        textFieldStack.addArrangedSubview(passwordTextField)
        
        loginButtonsStack.addArrangedSubview(forgotPasswordBurron)
        loginButtonsStack.addArrangedSubview(logInButton)
        
        textFieldStack.addArrangedSubview(loginButtonsStack)
        
        view.add(subviews: backgroundImage,textFieldStack, createAccountStack)
        backgroundImage.addSubview(logoImage)
        
        emailTextField.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 300, height: 40))
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 300, height: 40))
        }
        
        logInButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 300, height: 40))
        }
        
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
        
        textFieldStack.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
        }
        
        textFieldStack.setContentHuggingPriority(.sceneSizeStayPut, for: .vertical)
        createAccountStack.snp.makeConstraints { make in
               make.centerX.equalTo(view.snp.centerX)
               make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-24)
           }
    }
    
    func setupAppearance() {
        logoImage.image = UIImage(named: "AppIcon")
        logoImage.layer.cornerRadius = 20
        logoImage.layer.masksToBounds = false
        logoImage.clipsToBounds = true
        backgroundImage.image = UIImage(named: "backtest")
        createAccountLabel.text = "Don't  have an account?"
        createAccountLabel.textColor = .darkGray
        createAccountLabel.font = .systemFont(ofSize: 15)
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        emailTextField.keyboardType = .emailAddress
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        passwordTextField.textContentType = .oneTimeCode
        passwordTextField.isSecureTextEntry = true
    }
}
