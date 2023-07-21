//
//  ResetPasswordViewModel.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 21.07.2023.
//

import UIKit
import Combine
import FirebaseAuth

final class ResetPasswordViewModel {
    var emailText = CurrentValueSubject<String, Never>("")
    var formIsValid = CurrentValueSubject<Bool, Never>(false)
    var bag = Set<AnyCancellable>()
    
    init() {
        resetValidationPublishers
            .receive(on: RunLoop.main)
            .assign(to: \.formIsValid.value, on: self)
            .store(in: &bag)
    }
    
}

extension ResetPasswordViewModel {
    var resetValidationPublishers: AnyPublisher<Bool, Never> {
        return emailText
            .map { email in
                !email.isEmpty
            }
            .eraseToAnyPublisher()
    }
}

extension ResetPasswordViewModel {
    
    func formateAuthError(_ error: NSError) -> String {
        switch error.code {
        case AuthErrorCode.networkError.rawValue:
            return "Network Error"
        case AuthErrorCode.userDisabled.rawValue:
            return "Account is banned"
        case AuthErrorCode.userNotFound.rawValue:
            return "User not exist"
        case AuthErrorCode.invalidEmail.rawValue:
            return "Invalid email"
        default:
            return "unknown error: \(error.localizedDescription)"
        }
    }
    
    func showAlert(title: String, message: String, vc: ResetPasswordViewController, handler:((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: handler)
        alertController.addAction(okAction)
        vc.present(alertController, animated: true, completion: nil)
    }
}
