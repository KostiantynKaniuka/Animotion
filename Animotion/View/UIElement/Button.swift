//
//  Button.swift
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


final class LogoutButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        buttonSettings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buttonSettings() {
        let attributedText = NSMutableAttributedString(string: "Log out", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12),
            NSAttributedString.Key.foregroundColor: UIColor.darkGray,
            NSAttributedString.Key.kern: 1
        ])
        var logoutButtonConfiguration = UIButton.Configuration.gray()
        logoutButtonConfiguration.baseBackgroundColor = .white
        self.configuration = logoutButtonConfiguration
        self.setAttributedTitle(attributedText, for: .normal)
    }
}

final class DeleteAccountButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        buttonSettings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buttonSettings() {
        let attributedText = NSMutableAttributedString(string: "Delete account", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.kern: 1
        ])
        let deleteButtonConfiguration = UIButton.Configuration.plain()
        
        self.configuration = deleteButtonConfiguration
        self.setAttributedTitle(attributedText, for: .normal)
        self.contentHorizontalAlignment = .left
       
    }
}

final class EditAccountButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        buttonSettings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buttonSettings() {
        let attributedText = NSMutableAttributedString(string: "Edit", attributes: [
           
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.kern: 1
        ])
        self.setImage(UIImage(systemName: "gear"), for: .normal)
        self.tintColor = .white
        let editButtonConfiguration = UIButton.Configuration.plain()        
        self.configuration = editButtonConfiguration
        self.setAttributedTitle(attributedText, for: .normal)
        self.contentHorizontalAlignment = .left
    }
}

final class CreateAccountButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        buttonSettings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buttonSettings() {
        let attributedText = NSMutableAttributedString(string: "Create Account", attributes: [
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
        self.titleLabel?.textAlignment = .center
    }
}
