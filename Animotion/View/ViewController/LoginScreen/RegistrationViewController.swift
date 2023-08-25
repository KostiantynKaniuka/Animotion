//
//  RegistrationViewController.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 18.07.2023.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa
import FirebaseAuth

final class RegistrationViewController: UIViewController {
    
    //MARK: - UI OUTLETS
    private let profileImage = UIImageView()
    private let backgroundImage = UIImageView()
    private var textFieldStack = UIStackView()
    private var buttonsStackView = UIStackView()
    private lazy var labelStack = UIStackView()
    private lazy var labelView = UIView()
    private lazy var specialCharacterLabel = CustomLabel()
    private lazy var minNumberOfCharactersLabel = CustomLabel()
    private lazy var containDidgitLabel = CustomLabel()
    private lazy var containUpperRegisterLabel = CustomLabel()
    private lazy var containLowerRegisterLabel = CustomLabel()
    private lazy var fieldsDontMatchLabel = CustomLabel()
    private let nameTextField = CustomTextField()
    private let emailTextField = CustomTextField()
    private let passwordTextField = PasswordTextField()
    private let repeatPasswordTextField = PasswordTextField()
    private let createAccButton = CreateAccountButton()
    private let cancelRegistrationButton = CancelRegistrationButton()
    
    //MARK: - PROPERTIES
    private let registrationVM = RegistrationViewModel()
    private var isViewShiftedUp = false
    private var alertMessage: AlertMessage = .error
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dealingWithKeyboard()
        setUpAppearance()
        setUpConstraints()
        bindTextfields()
        matchValidationColor()
        createUserTapped()
        passwordTextField.delegate = self
        repeatPasswordTextField.delegate = self
        emailTextField.delegate = self
        nameTextField.delegate = self
        cancelRegistrationButton.tapPublisher
            .sink { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .store(in: &registrationVM.bag)
    }
    
    private func removeValidationLabelsFromStackView() {
        if passwordTextField.resignFirstResponder() {
            textFieldStack.removeArrangedSubview(labelView)
            labelView.removeFromSuperview()
        }
    }
    
    private func createUserTapped() {
        createAccButton.tapPublisher
            .sink { [weak self] _ in
                guard let self = self else {return}
                Auth.auth().createUser(withEmail: self.registrationVM.emailText.value,
                                       password: self.registrationVM.passwordText.value) { authResult, error in
                    
                    if let error = error as NSError? {
                        self.alertMessage = .error
                        let message  = self.registrationVM.formateAuthError(error)
                        self.registrationVM.showAlert(title: self.alertMessage.title,
                                                      message: message, vc: self)
                    }
                    
                    if authResult != nil {
                        
                        Auth.auth().currentUser?.sendEmailVerification { error in
                            if let error = error as NSError? {
                                self.alertMessage = .error
                                let message  = self.registrationVM.formateAuthError(error)
                                self.registrationVM.showAlert(title: self.alertMessage.title,
                                                              message: message, vc: self)
                                Auth.auth().currentUser?.delete()
                            }
                        }
                    }
                }
                self.alertMessage = .verification
                self.registrationVM.showAlert(title: self.alertMessage.title,
                                              message: self.alertMessage.body,
                                              vc: self) { _ in
                    
                    self.dismiss(animated: true)
                }
            }
            .store(in: &registrationVM.bag)
    }
    
    private func bindTextfields() {
        passwordTextField.textPublisher
            .sink { [weak self] text in
                self?.registrationVM.passwordText.value = text ?? ""
            }
            .store(in: &registrationVM.bag)
        
        nameTextField.textPublisher
            .sink { [weak self] text in
                self?.registrationVM.nameText.value = text ?? ""
            }
            .store(in: &registrationVM.bag)
        
        repeatPasswordTextField.textPublisher
            .sink { [weak self] text in
                self?.registrationVM.repeatPasswordText.value = text ?? ""
            }
            .store(in: &registrationVM.bag)
        
        emailTextField.textPublisher
            .sink { [weak self] text in
                self?.registrationVM.emailText.value = text ?? ""
            }
            .store(in: &registrationVM.bag)
        
        registrationVM.formIsValid
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: createAccButton)
            .store(in: &registrationVM.bag)
    }
    
    private func matchValidationColor() {
        registrationVM.isContainDigitValidPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isContain in
                self?.containDidgitLabel.textColor = isContain ? .systemGreen : .red
            }
            .store(in: &registrationVM.bag)
        
        registrationVM.isContainLowerRegisterValidPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isContain in
                self?.containLowerRegisterLabel.textColor = isContain ? .systemGreen : .red
            }
            .store(in: &registrationVM.bag)
        
        registrationVM.isContainUpperRegisterValidPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isContain in
                self?.containUpperRegisterLabel.textColor = isContain ? .systemGreen : .red
            }
            .store(in: &registrationVM.bag)
        
        registrationVM.isContainSpecialCharacterValidPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isContain in
                self?.specialCharacterLabel.textColor = isContain ? .systemGreen : .red
            }
            .store(in: &registrationVM.bag)
        
        registrationVM.isMinNumberOfCharactersValidPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isContain in
                self?.minNumberOfCharactersLabel.textColor = isContain ? .systemGreen : .red
            }
            .store(in: &registrationVM.bag)
        
        registrationVM.isUserNameValidPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                self?.nameTextField.textColor = isValid ? .black : .red
            }
            .store(in: &registrationVM.bag)
        
        
        registrationVM.isPasswordEqualPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isMatch in
                guard let self = self else {return}
                self.setTextFieldValidColor(isMatch)
            }
            .store(in: &registrationVM.bag)
    }
    
    private func setTextFieldValidColor(_ isMatch: Bool) {
        if !isMatch && self.repeatPasswordTextField.isFirstResponder {
            self.repeatPasswordTextField.layer.shadowColor = UIColor.systemRed.cgColor
            self.repeatPasswordTextField.layer.borderColor = UIColor.systemRed.cgColor
            self.view.addSubview(self.fieldsDontMatchLabel)
            self.fieldsDontMatchLabel.snp.makeConstraints { make in
                make.centerX.equalTo(self.textFieldStack.snp.centerX)
                make.bottom.equalTo(self.repeatPasswordTextField.snp.top).offset(15)
            }
        } else {
            self.repeatPasswordTextField.layer.shadowColor = UIColor.lightGray.cgColor
            self.repeatPasswordTextField.layer.borderColor = UIColor.lightGray.cgColor
            self.fieldsDontMatchLabel.removeFromSuperview()
        }
    }
    
    deinit {
        print("➡️ registration gone")
    }
}

//MARK: - TEXT FIELD DELEGATE
extension RegistrationViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == passwordTextField {
            setupLabels()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == passwordTextField {
            removeValidationLabelsFromStackView()
        }
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let text = textField.text ?? ""
        let updatedText = (text as NSString).replacingCharacters(in: range,
                                                                 with: string)
        if textField != nameTextField {
            if updatedText.count > 42 || string.contains(" ") {
                return false
            } else {
                return true
            }
        } else {
                if updatedText.count > 42 {
                    return false
                } else {
                    return true
                }
            }
    }
}

//MARK: - Layout
extension RegistrationViewController {
    
    private func setUpConstraints() {
        textFieldStack.spacing = 20
        textFieldStack.alignment = .center
        textFieldStack.axis = .vertical
        textFieldStack.distribution = .fill
        
        buttonsStackView.spacing = 20
        buttonsStackView.alignment = .center
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .fill
        
        view.addSubview(backgroundImage)
        view.addSubview(profileImage)
        view.addSubview(textFieldStack)
        view.addSubview(buttonsStackView)
    
        buttonsStackView.addArrangedSubviews([createAccButton,
                                              cancelRegistrationButton])
        
        textFieldStack.addArrangedSubview(nameTextField)
        textFieldStack.addArrangedSubview(emailTextField)
        textFieldStack.addArrangedSubview(passwordTextField)
        textFieldStack.addArrangedSubview(repeatPasswordTextField)
        textFieldStack.addArrangedSubview(buttonsStackView)
        
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
        
        profileImage.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 100, height: 100))
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(textFieldStack.snp.top).offset(-50)
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
            make.size.equalTo(CGSize(width: 100, height: 50))
        }
        
        cancelRegistrationButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 100, height: 50))
        }
        
    }
    
    private func setUpAppearance() {
        profileImage.image = UIImage(named: "back 1")
        profileImage.frame.size = CGSize(width: 100, height: 100)
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        
        backgroundImage.image = UIImage(named: "backtest")
        nameTextField.attributedPlaceholder =
        NSAttributedString(string: "Enter your name",
                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        emailTextField.attributedPlaceholder =
        NSAttributedString(string: "Email",
                          attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        emailTextField.keyboardType = .emailAddress
        
        passwordTextField.attributedPlaceholder =
        NSAttributedString(string: "Password",
                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        passwordTextField.textContentType = .oneTimeCode
        passwordTextField.isSecureTextEntry = true
        
        repeatPasswordTextField.attributedPlaceholder =
        NSAttributedString(string: "Repeat password",
                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        repeatPasswordTextField.textContentType = .oneTimeCode
        repeatPasswordTextField.isSecureTextEntry = true
    }
    
    private func setupLabels() {
        specialCharacterLabel.text = "·must contain at least one special character"
        containDidgitLabel.text = "·must contain at least one digit"
        containUpperRegisterLabel.text = "·must contain one letter from upper register"
        containLowerRegisterLabel.text = "·must contain one letter from lower register"
        minNumberOfCharactersLabel.text = "·must contain at least 8 characters"
        fieldsDontMatchLabel.text = "Fields isn't match"
        fieldsDontMatchLabel.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 300, height: 50))
        }
        fieldsDontMatchLabel.textAlignment = .center
        fieldsDontMatchLabel.font = .boldSystemFont(ofSize: 13)
        
        labelView.backgroundColor = .clear
        
        labelStack.spacing = 5
        labelStack.alignment = .leading
        labelStack.axis = .vertical
        labelStack.distribution = .fillEqually
        labelStack.addArrangedSubview(minNumberOfCharactersLabel)
        labelStack.addArrangedSubview(containLowerRegisterLabel)
        labelStack.addArrangedSubview(containUpperRegisterLabel)
        labelStack.addArrangedSubview(containDidgitLabel)
        labelStack.addArrangedSubview(specialCharacterLabel)
        labelView.addSubview(labelStack)
        
        labelView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 300, height: 90))
        }
        
        labelStack.snp.makeConstraints { make in
            make.bottom.equalTo(labelView.snp.bottom)
            make.top.equalTo(labelView.snp.top)
            make.left.equalTo(labelView.snp.left)
            make.right.equalTo(labelView.snp.right)
        }
        
        labelStack.alpha = 0.0
        
        labelStack.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        
        textFieldStack.insertArrangedSubview(labelView, at: 2)
        
        UIView.animate(withDuration: 0.3) {
            self.labelStack.alpha = 1.0
            self.labelStack.transform = .identity
        }
    }
}

//MARK: - Keybord Apperiance
extension RegistrationViewController {
    
    private func shiftViewUp() {
        if !isViewShiftedUp {
            textFieldStack.snp.updateConstraints { make in
                make.centerY.equalTo(view.snp.centerY).offset(-100)
                isViewShiftedUp = true
            }
            
        }
    }
    
    private func resetViewPosition() {
        if isViewShiftedUp {
            textFieldStack.snp.updateConstraints { make in
                make.centerY.equalTo(view.snp.centerY)
                isViewShiftedUp = false
            }
        }
    }
    
    private func dealingWithKeyboard() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .sink { [weak self] _ in
                guard let self = self else {return}
                
                if self.isViewShiftedUp == false {
                    self.shiftViewUp()
                }
            }
            .store(in: &registrationVM.bag)
        
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .sink { [weak self] _ in
                guard let self = self else {return}
                
                self.resetViewPosition()
                self.view.layoutIfNeeded()
            }
            .store(in: &registrationVM.bag)
    }
}
