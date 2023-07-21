//
//  UserScreenViewController.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 10.07.2023.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa
import FirebaseAuth

protocol LogoutDelegate: AnyObject {
    func didLogout()
}

final class UserScreenViewController: UIViewController {
    private let backgroundImage =       UIImageView()
    private let moodChartLabel =        UILabel()
    private let privacyPolicy =         UILabel()
    private let chartView =             UIImageView()
    private let userNameField =         UITextView()
    private var userImage =             UIImageView()
    private let logOutButton =          LogoutButton()
    private let editButton =            EditAccountButton()
    private let deleteAccountButton =   DeleteAccountButton()
    private let buttonsStack =          UIStackView()
    private let userScreenVM =          UserScreenViewModel()
    
    private var alertMessage: AlertMessage = .error
    weak var logoutDelegate: LogoutDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        logOutButton.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupAppearance()
        setupConstaints()
        deleteButtonTapped()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    private func deleteButtonTapped() {
        let user = Auth.auth().currentUser
        deleteAccountButton.tapPublisher
            .sink { [weak self] _ in
                guard let self = self else {return}
                self.alertMessage = .delete
                self.userScreenVM.showAlert(title: self.alertMessage.title,
                                            message: self.alertMessage.body,
                                            vc: self,
                                            handler: ({ _ in
                    user?.delete { error in
                      if let error = error as NSError? {
                         let message = self.userScreenVM.formateAuthError(error)
                          self.userScreenVM.showAlert(title: self.alertMessage.title,
                                                      message: message,
                                                      vc: self)
                      } else {
                          self.logoutDelegate?.didLogout()
                        print("😶‍🌫️ account deleted")
                      }
                    }
                }), cancelhadler: UIAlertAction())
            }
            .store(in: &userScreenVM.bag)
    }
    
    @objc private func logOutButtonTapped() {
        do {
               try Auth.auth().signOut()
               logoutDelegate?.didLogout()
           } catch {
               print("Unexpected error occurred while signing out: \(error)")
           }
    }
    
    deinit {
        print("➡️ user screen gone")
    }
}

//MARK: - layout
extension UserScreenViewController {
    
    private func setupConstaints() {
        view.add(subviews: backgroundImage,
                 userImage,
                 userNameField,
                 chartView,
                 moodChartLabel,
                 buttonsStack,
                 editButton,
                 privacyPolicy
        )
        
        buttonsStack.addArrangedSubview(logOutButton)
        buttonsStack.addArrangedSubview(deleteAccountButton)
        
        backgroundImage.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom)
            make.top.equalTo(view.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
        }
        
        chartView.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(300)
        }
        
        userImage.snp.makeConstraints { make in
            make.top.equalTo(view).offset(60)
            make.centerX.equalTo(view.snp.centerX)
            make.size.equalTo(CGSize(width: 80, height: 80))
        }
        
        userNameField.snp.makeConstraints { make in
            make.top.equalTo(userImage.snp.bottom).offset(8)
            make.centerX.equalTo(userImage.snp.centerX)
            make.size.equalTo(CGSize(width: 350, height: 40))
        }
        
        moodChartLabel.snp.makeConstraints { make in
            make.centerX.equalTo(chartView)
            make.bottom.equalTo(chartView.snp.top).offset(-16)
        }
        
        logOutButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 100, height: 40))
        }
        
        deleteAccountButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 100, height: 40))
        }
        
        buttonsStack.snp.makeConstraints { make in
            make.centerX.equalTo(chartView)
            make.top.equalTo(chartView.snp.bottom).offset(60)
        }
        
        editButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 100, height: 40))
            make.top.equalTo(buttonsStack.snp.bottom).offset(8)
            make.centerX.equalTo(chartView)
        }
        
        privacyPolicy.snp.makeConstraints { make in
            make.bottom.equalTo(view).offset(-32)
            make.centerX.equalTo(buttonsStack)
        }
    }
    
    private func setupAppearance() {
        privacyPolicy.text =                "Privacy policy"
        privacyPolicy.textColor =           .darkGray
        privacyPolicy.font =                .systemFont(ofSize: 12)
        
        buttonsStack.spacing =              5
        buttonsStack.alignment =            .fill
        buttonsStack.axis =                 .horizontal
        buttonsStack.distribution =         .fill
        
        chartView.image =                   UIImage(named: "chart2")
        chartView.contentMode =             .scaleAspectFit
        chartView.backgroundColor =         .darkGray
        chartView.layer.borderWidth =       1
        chartView.layer.borderColor =       UIColor.white.cgColor
        
        moodChartLabel.text =               "Your mood chart"
        moodChartLabel.font =               .systemFont(ofSize: 20)
        
        userImage.image =                   UIImage(named: "back 1")
        userImage.frame.size =              CGSize(width: 80, height: 80)
        userImage.layer.borderWidth =       1
        userImage.layer.borderColor =       UIColor.white.cgColor
        userImage.layer.cornerRadius =      userImage.frame.size.width / 2
        userImage.layer.masksToBounds =     false
        userImage.clipsToBounds =           true
        
        userNameField.text =                "User name"
        userNameField.font =                .systemFont(ofSize: 17)
        userNameField.textAlignment =       .center
        userNameField.textColor =           .white
        userNameField.textContainer
            .maximumNumberOfLines =         1
        userNameField.isEditable =          true
        userNameField.backgroundColor =     .clear
        backgroundImage.image =             UIImage(named: "backtest")
    }
}
