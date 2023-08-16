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
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
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
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.systemBlue,
            NSAttributedString.Key.kern: 1
        ])
        let forgotButtonConfiguration = UIButton.Configuration.plain()
        
        self.configuration = forgotButtonConfiguration
        self.setAttributedTitle(attributedText, for: .normal)
        self.contentHorizontalAlignment = .right
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
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.kern: 1
        ])
        var loginButtonConfiguration = UIButton.Configuration.gray()
        loginButtonConfiguration.baseBackgroundColor = .systemBlue
        self.configuration = loginButtonConfiguration
        self.setAttributedTitle(attributedText, for: .normal)
        self.layer.shadowRadius = 3.0
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSizeMake(1.0, 1.0)
        self.layer.shadowOpacity = 1.0
        self.titleLabel?.textAlignment = .center
    }
}
    
    final class CancelRegistrationButton: UIButton {
        
        override init(frame: CGRect) {
            super.init(frame:frame)
            buttonSettings()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func buttonSettings() {
            let attributedText = NSMutableAttributedString(string: "Cancel", attributes: [
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

final class ResetPasswordButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        buttonSettings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buttonSettings() {
        let attributedText = NSMutableAttributedString(string: "Reset password", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.white,
        ])
        var loginButtonConfiguration = UIButton.Configuration.gray()
        loginButtonConfiguration.baseBackgroundColor = .systemBlue
        self.configuration = loginButtonConfiguration
        self.setAttributedTitle(attributedText, for: .normal)
        self.layer.shadowRadius = 3.0
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSizeMake(1.0, 1.0)
        self.layer.shadowOpacity = 1.0
        self.titleLabel?.textAlignment = .center
    }
}

final class GoogleSignInButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        buttonSettings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buttonSettings() {
        self.setImage(UIImage(named: "googleicon"), for: .normal)
        let attributedText = NSMutableAttributedString(string: "Sign in with Google", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.black,
        ])
        let loginButtonConfiguration = UIButton.Configuration.plain()
        self.configuration = loginButtonConfiguration
        self.setAttributedTitle(attributedText, for: .normal)
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
    }
}
    
    final class AppleSignInButton: UIButton {
        
        override init(frame: CGRect) {
            super.init(frame:frame)
            buttonSettings()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        
        }
        private func buttonSettings() {
            self.setImage(UIImage(named: "appleicon"), for: .normal)
           
            let attributedText = NSMutableAttributedString(string: "Sign in with Apple  ", attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor: UIColor.black,
            ])
            let loginButtonConfiguration = UIButton.Configuration.plain()
            self.configuration = loginButtonConfiguration
            self.contentHorizontalAlignment = .center
       
            self.setAttributedTitle(attributedText, for: .normal)
            self.backgroundColor = .white
            self.layer.cornerRadius = 10
        }
}


final class SubmitButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        buttonSettings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buttonSettings() {
        let attributedText = NSMutableAttributedString(string: "Submit", attributes: [
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

final class CancelCaptureButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        buttonSettings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buttonSettings() {
        let attributedText = NSMutableAttributedString(string: "Cancel", attributes: [
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
