//
//  ResetPasswordViewController.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 21.07.2023.
//

import UIKit
import SnapKit
import FirebaseAuth
import Combine
import CombineCocoa

final class ResetPasswordViewController: UIViewController {
    private let topView = UIView()
    private let topImage = UIImageView()
    private let stackView = UIStackView()
    private let emailTextField = CustomTextField()
    private let resetPasswordButton = ResetPasswordButton()
    private let resetPasswordVM = ResetPasswordViewModel()
    private var alertMessage: AlertMessage = .error
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGradient()
        emailTextField.delegate = self
        emailTextField.becomeFirstResponder()
        setUpAperance()
        setUpConstraints()
        bindTextfield()
        resetPasswordButtonTapped()
    }
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.clear.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.frame = view.bounds
        topView.layer.addSublayer(gradientLayer)
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.top.equalTo(view.snp.top)
            make.height.equalTo(50)
        }
    }
    
    private func bindTextfield() {
        emailTextField.textPublisher
            .sink { [weak self] text in
                self?.resetPasswordVM.emailText.value = text ?? ""
            }
            .store(in: &resetPasswordVM.bag)
        
        resetPasswordVM.formIsValid
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: resetPasswordButton)
            .store(in: &resetPasswordVM.bag)
    }
    
    private func resetPasswordButtonTapped() {
        resetPasswordButton.tapPublisher
            .sink { [weak self] _ in
                guard let self = self else {return}
                Auth.auth().sendPasswordReset(withEmail: self.resetPasswordVM.emailText.value) { error in
                    if let error = error as? NSError {
                        self.alertMessage = .error
                        
                        let message = self.resetPasswordVM.formateAuthError(error)
                        self.resetPasswordVM.showAlert(title: self.alertMessage.title,
                                                       message: message,
                                                       vc: self)
                        self.topImage.image = UIImage(systemName: "lock")
                        self.topImage.image = UIImage(systemName: "lock.open")
                    } else {
                        self.alertMessage = .reset
                        self.topImage.image = UIImage(systemName: "lock")
                        self.resetPasswordVM.showAlert(title: self.alertMessage.title, message: self.alertMessage.body, vc: self) { _ in
                            self.emailTextField.resignFirstResponder()
                            self.dismiss(animated: true)
                        }
                    }
                }
             
            }
            .store(in: &resetPasswordVM.bag)
    }
    
    deinit {
        self.emailTextField.resignFirstResponder()
        print("➡️ Reset screen gone")
    }
    
}

extension ResetPasswordViewController {
    
    private func setUpConstraints() {
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .fill
       
        //view.addSubview(topImage)
        view.addSubview(stackView)
        view.addSubview(topImage)
        stackView.addArrangedSubviews([emailTextField,
                                       resetPasswordButton])
        
        topImage.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(emailTextField.snp.top).offset(-50)
        }
        
        topImage.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 100, height: 100))
        }
   
        stackView.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 300, height: 40))
        }
        resetPasswordButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 300, height: 40))
        }
    }
    
    private func setUpAperance() {
        view.backgroundColor = .appBackground
        
        topImage.image = UIImage(systemName: "lock.open")
        topImage.contentMode = .scaleAspectFill
        topImage.tintColor = .lightGray
        emailTextField.attributedPlaceholder =
        NSAttributedString(string: "Enter your email",
                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        emailTextField.textContentType = .emailAddress
        emailTextField.keyboardType = .emailAddress
    }
}

extension ResetPasswordViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let text = textField.text ?? ""
        let updatedText = (text as NSString).replacingCharacters(in: range,
                                                                 with: string)
        if updatedText.count > 42 {
            return false
        } else {
            return true
        }
    }
}
