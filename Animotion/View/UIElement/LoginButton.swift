//
//  LoginButton.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 10.07.2023.
//

import UIKit

final class LoginButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        buttonSettings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buttonSettings() {
        let attributedText = NSMutableAttributedString(string: "Sign in", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17),
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.kern: 1
        ])
        var loginButtonConfiguration = UIButton.Configuration.gray()
        loginButtonConfiguration.baseBackgroundColor = .systemBlue
        self.configuration = loginButtonConfiguration
        self.setAttributedTitle(attributedText, for: .normal)
        self.layer.shadowRadius = 3.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSizeMake(1.0, 1.0)
        self.layer.shadowOpacity = 1.0
    }
}


final class ForgotPassButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        buttonSettings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buttonSettings() {
        let attributedText = NSMutableAttributedString(string: "Forgot password?", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
            NSAttributedString.Key.foregroundColor: UIColor.systemBlue,
            NSAttributedString.Key.kern: 1
        ])
        let forgotButtonConfiguration = UIButton.Configuration.plain()
        
        self.configuration = forgotButtonConfiguration
        self.setAttributedTitle(attributedText, for: .normal)
        self.contentHorizontalAlignment = .left
    }
}

final class DontHaveAccountButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        buttonSettings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buttonSettings() {
        let attributedText = NSMutableAttributedString(string: "Sign up!", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
            NSAttributedString.Key.foregroundColor: UIColor.systemBlue,
            NSAttributedString.Key.kern: 1
        ])
        let forgotButtonConfiguration = UIButton.Configuration.plain()
        
        self.configuration = forgotButtonConfiguration
        self.setAttributedTitle(attributedText, for: .normal)
        self.contentHorizontalAlignment = .left
    }
}
