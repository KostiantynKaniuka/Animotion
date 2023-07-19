//
//  LoginTextfiel.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 10.07.2023.
//

import UIKit
import Combine
import CombineCocoa

final class CustomTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        textFieldSettings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func textFieldSettings() {
        self.backgroundColor = .white
        self.font = UIFont(name: "SanFrancisco", size: 17)
        self.textAlignment = .left
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 3.0
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSizeMake(1.0, 1.0)
        self.layer.shadowOpacity = 1.0
        self.textColor = .black
        self.autocapitalizationType = .none
        self.setLeftPaddingPoints(8)
        self.setRightPaddingPoints(8)
    }
}

final class PasswordTextField: UITextField {
    private let eyeButton = UIButton(type: .custom)
    private var isPasswordVisible = false
    private var bag = Set<AnyCancellable>()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        textFieldSettings()
        eyeButton.tapPublisher
            .sink { [weak self] _ in
                guard let self = self else {return}
                self.togglePasswordVisibility()
                if !self.isSecureTextEntry {
                    self.eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
                } else {
                    self.eyeButton.setImage(UIImage(systemName: "eye"), for: .normal)
                }
            }
            .store(in: &bag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func textFieldSettings() {
        let eyeIconImage = UIImage(systemName: "eye")
               eyeButton.setImage(eyeIconImage, for: .normal)
               eyeButton.contentMode = .center
               eyeButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        eyeButton.tintColor = .lightGray
        self.backgroundColor = .white
        self.font = UIFont(name: "SanFrancisco", size: 17)
        self.textAlignment = .left
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 3.0
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSizeMake(1.0, 1.0)
        self.layer.shadowOpacity = 1.0
        self.textColor = .black
        self.setLeftPaddingPoints(8)
        self.setRightPaddingPoints(8)
        rightView = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
                rightView?.addSubview(eyeButton)
                rightViewMode = .always
        self.rightViewMode = .always
    }
}
