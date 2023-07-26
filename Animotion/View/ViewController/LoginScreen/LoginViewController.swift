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
import GoogleSignIn

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
    private let serviceLogInStack = UIStackView()
    private let createAccountLabel = UILabel()
    private let logInButton = LoginButton()
    private let googleSignInButton = GoogleSignInButton()
    private let appleSignInButton = AppleSignInButton()
    private let deviderLabel = UILabel()
    private let leadingDevider = DevideView()
    private let trailingDevider = DevideView()
    private let deviderStack = UIStackView()
    private let forgotPasswordButton = ForgotPassButton()
    private let dontHaveAccoutButton = DontHaveAccountButton()
    private let loginVM = LoginViewModel()
    weak var loginDelegate: LoginViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        logInButton.addTarget(self, action: #selector(sigInButtonTapped), for: .touchUpInside)
        googleSignInButton.addTarget(self, action: #selector(googleSingInButtonTappes), for: .touchUpInside)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        bindTextField()
        dontHaveAccoutButtonTapped()
        forgotPasswordBurronTapped()
        
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
    
    @objc private func googleSingInButtonTappes()  {
        loginVM.loginWithGoogleDoc(self) { [weak self] in
            self?.loginDelegate?.didLogin()
        }
    }
                
    private func forgotPasswordBurronTapped() {
        forgotPasswordButton.tapPublisher
            .sink { [weak self] _ in
                guard let self = self else {return}
                let vc = ResetPasswordViewController()
                vc.modalPresentationStyle = .pageSheet
                self.present(vc, animated: true)
            }
            .store(in: &loginVM.subscriptions)
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
        
        deviderStack.alignment = .center
        deviderStack.axis = .horizontal
        deviderStack.distribution = .fill
        
        serviceLogInStack.spacing = 20
        serviceLogInStack.alignment = .fill
        serviceLogInStack.axis = .vertical
        serviceLogInStack.distribution = .fill
        
        textFieldStack.spacing = 20
        textFieldStack.alignment = .fill
        textFieldStack.axis = .vertical
        textFieldStack.distribution = .fill
        
        deviderStack.addArrangedSubviews([leadingDevider,deviderLabel,trailingDevider])
        
        serviceLogInStack.addArrangedSubviews([appleSignInButton, googleSignInButton])
        createAccountStack.addArrangedSubview(createAccountLabel)
        createAccountStack.addArrangedSubview(dontHaveAccoutButton)
     
        textFieldStack.addArrangedSubview(emailTextField)
        textFieldStack.addArrangedSubview(passwordTextField)
        
        loginButtonsStack.addArrangedSubview(forgotPasswordButton)
        loginButtonsStack.addArrangedSubview(logInButton)
        loginButtonsStack.addArrangedSubview(deviderStack)
       
        textFieldStack.addArrangedSubview(loginButtonsStack)
        
        view.add(subviews: backgroundImage,textFieldStack, createAccountStack,serviceLogInStack)
        backgroundImage.addSubview(logoImage)
        
      
          
        trailingDevider.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 125, height: 1))
        }
        
        leadingDevider.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 125, height: 1))
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
        
        googleSignInButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 300, height: 40))
        }
      
      appleSignInButton.snp.makeConstraints { make in
          make.size.equalTo(CGSize(width: 300, height: 40))
      }
      
      serviceLogInStack.snp.makeConstraints { make in
          make.centerX.equalTo(view.snp.centerX)
          make.top.equalTo(logInButton.snp.bottom).offset(50)
          
      }
        
        textFieldStack.setContentHuggingPriority(.sceneSizeStayPut, for: .vertical)
        createAccountStack.snp.makeConstraints { make in
               make.centerX.equalTo(view.snp.centerX)
               make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-24)
           }
    }
    
    func setupAppearance() {
        googleSignInButton.frame.size = CGSize(width: 300, height: 40)
        appleSignInButton.frame.size = CGSize(width: 300, height: 40)
      
        
        
        logoImage.image = UIImage(named: "AppIcon")
        logoImage.layer.cornerRadius = 20
        logoImage.layer.masksToBounds = false
        logoImage.clipsToBounds = true
        backgroundImage.image = UIImage(named: "backtest")
        createAccountLabel.text = "Don't  have an account?"
        createAccountLabel.textColor = .darkGray
        createAccountLabel.font = .systemFont(ofSize: 15)
        
        deviderLabel.text = "or"
        deviderLabel.textColor = .darkGray
        deviderLabel.font = .systemFont(ofSize: 15)
        deviderLabel.textAlignment = .center
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        emailTextField.keyboardType = .emailAddress
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        passwordTextField.textContentType = .oneTimeCode
        passwordTextField.isSecureTextEntry = true
    }
}
