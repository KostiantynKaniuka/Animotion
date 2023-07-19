//
//  LoginViewModel.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 18.07.2023.
//

import Foundation
import Combine
import FirebaseAuth

final class LoginViewModel {
    var emailText = CurrentValueSubject<String, Never>("")
    var passwordText = CurrentValueSubject<String, Never>("")
    var subscriptions = Set<AnyCancellable>()
    
    
    var signinValidationPublishers: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest(passwordText, emailText)
            .map {  passwordText, emailText in
                !passwordText.isEmpty && !emailText.isEmpty
            }
            .eraseToAnyPublisher()
    }
    
    
    
    func formateAuthError(_ error: NSError) -> String {
        switch error.code {
        case AuthErrorCode.wrongPassword.rawValue:
            return "Wrong password"
        case AuthErrorCode.invalidEmail.rawValue:
            return "Invalid email"
        case AuthErrorCode.accountExistsWithDifferentCredential.rawValue:
            return "Account exists with different credential"
        case AuthErrorCode.networkError.rawValue:
            return "Network Error"
        case AuthErrorCode.userDisabled.rawValue:
            return "Accouont is banned"
        case AuthErrorCode.userNotFound.rawValue:
            return "User not exist"
        default:
            return "unknown error: \(error.localizedDescription)"
        }
    }
    
    func showAlert(message: String, vc: LoginViewController) {
        let alertController = UIAlertController(title: "Oops", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        vc.present(alertController, animated: true, completion: nil)
    }
}
