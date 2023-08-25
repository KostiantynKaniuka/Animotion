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
import AuthenticationServices

protocol LoginViewControllerDelegate: AnyObject {
    func didLogin()
}

final class LoginViewController: UIViewController {
    //MARK: - UI OUTLETS
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
    //private let applebutton = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
    
    //MARK: - PROPERTIES
    private let loginVM = LoginViewModel()
    weak var loginDelegate: LoginViewControllerDelegate?
    fileprivate var currentNonce: String?
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        logInButton.addTarget(self, action: #selector(sigInButtonTapped),
                              for: .touchUpInside)
        googleSignInButton.addTarget(self, action: #selector(googleSingInButtonTappes),
                                     for: .touchUpInside)
        appleSignInButton.addTarget(self, action: #selector(siginWithApple),
                                    for: .touchUpInside)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        bindTextField()
        dontHaveAccoutButtonTapped()
        forgotPasswordBurronTapped()
        
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
    
    //MARK: - METHODS
    
    private func startSignInWithAppleFlow() {
        let nonce = loginVM.randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = loginVM.sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
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
    
    //MARK: - @OBJC LOGIN ACTIONS
    @objc private func sigInButtonTapped() {
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
                    guard let user = user else {return}
                    FireAPIManager.shared.checkUserIndb(user.uid) { isExist in
                        if isExist {
                            self.loginDelegate?.didLogin()
                        } else {
                            //MARK: - CREATING USER IN DB
                            let dateConverter = DateConvertor()
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
                            let currentDate = dateFormatter.string(from: Date())
                            let formatedDate = dateFormatter.date(from: currentDate)
                            let doubleDate = dateConverter.convertDateToNum(date: formatedDate!)
                            let radarData = [
                                "Happy": 0,
                                "Good": 0,
                                "Satisfied": 0,
                                "Anxious": 0,
                                "Angry": 0,
                                "Sad": 0
                            ]
                            let user = MyUser(id: user.uid, name: "Name", radarData: radarData)
                            let userGraph = GraphData(index: 0, date: doubleDate, value: 5, reason: "starting point")
                            FireAPIManager.shared.addingUserToFirebase(user: user)
                            FireAPIManager.shared.addGraphData(id: user.id, graphData: userGraph)
                            print(user)
                            print("➡️ user added")
                            self.loginDelegate?.didLogin()
                        }
                    }
                   
                    
                    
                   
                }
                else {
                    self.loginVM.showAlert(message: "Please verify your email", vc: self)
                }
            }
            
        }
    }
    
    @objc private func siginWithApple() {
        startSignInWithAppleFlow()
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

//MARK: - TextFields Delegate
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



//MARK: - Apple SignIn DELEGATE
extension LoginViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                           rawNonce: nonce,
                                                           fullName: appleIDCredential.fullName)
            // Sign in with Firebase.
            
            loginVM.signInWithAppleCred(credential, vc: self) { [unowned self] in
                self.loginDelegate?.didLogin()
            }
        }
    }
    
//MARK: - Apple AUTH ERORR
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        guard let error = error as? ASAuthorizationError else {return}
        let message = loginVM.formateAppleAuthError(error)
        loginVM.showAlert(message: message, vc: self)
        print("Sign in with Apple errored: \(error)")
    }
    
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        
        guard let window = view?.window else {
            return keyWindow ?? ASPresentationAnchor()
        }
        return window
    }
}

//MARK: - LayoutConstraints
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
        
        deviderStack.addArrangedSubviews([leadingDevider,
                                          deviderLabel,
                                          trailingDevider])
        
        serviceLogInStack.addArrangedSubviews([appleSignInButton,
                                               googleSignInButton])
        
        createAccountStack.addArrangedSubview(createAccountLabel)
        createAccountStack.addArrangedSubview(dontHaveAccoutButton)
        
        textFieldStack.addArrangedSubview(emailTextField)
        textFieldStack.addArrangedSubview(passwordTextField)
        
        loginButtonsStack.addArrangedSubview(forgotPasswordButton)
        loginButtonsStack.addArrangedSubview(logInButton)
        loginButtonsStack.addArrangedSubview(deviderStack)
        
        textFieldStack.addArrangedSubview(loginButtonsStack)
        
        view.add(subviews: backgroundImage,
                 textFieldStack,
                 createAccountStack,
                 serviceLogInStack)
        
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
        
        if UIScreen.main.bounds.size.height < 812 {
            backgroundImage.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.top.bottom.equalToSuperview()
                make.left.right.equalToSuperview().inset(-8)
            }
        } else {
            backgroundImage.snp.makeConstraints { make in
                make.top.bottom.right.left.equalToSuperview()
            }
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
//        applebutton.snp.makeConstraints { make in
//            make.size.equalTo(CGSize(width: 300, height: 40))
//        }
        
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
    
    //MARK: - UI Style
    func setupAppearance() {
        googleSignInButton.frame.size = CGSize(width: 300, height: 40)
        appleSignInButton.frame.size = CGSize(width: 300, height: 40)
        //applebutton.frame.size = CGSize(width: 300, height: 400)
        
        
        logoImage.image = UIImage(named: "Icon2")
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
