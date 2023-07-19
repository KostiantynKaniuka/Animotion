//
//  RegistrationViewModel.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 18.07.2023.
//

import Foundation
import Combine

final class RegistrationViewModel {
    var emailText = CurrentValueSubject<String, Never>("")
    var passwordText = CurrentValueSubject<String, Never>("")
    var repeatPasswordText = CurrentValueSubject<String, Never>("")
    var nameText = CurrentValueSubject<String, Never>("")
    var formIsValid = CurrentValueSubject<Bool, Never>(false)
    var bag = Set<AnyCancellable>()
    
    init() {
        isSignupFormValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.formIsValid.value, on: self)
            .store(in: &bag)
    }
}

//MARK: - Validation rules
extension RegistrationViewModel {
    var isUserNameValidPublisher: AnyPublisher<Bool, Never> {
        nameText
            .map { name in
                return name.count >= 3 && name.count <= 30
            }
            .eraseToAnyPublisher()
    }
    
    var isUserEmailValidPublisher: AnyPublisher<Bool, Never> {
        emailText
            .map { email in
                let emailPredicate = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
                return emailPredicate.evaluate(with: email)
            }
            .eraseToAnyPublisher()
    }
    
    var isPasswordValidPublisher: AnyPublisher<Bool, Never> {
        passwordText
            .map { password in
                let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,64}"
                let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
                return passwordPredicate.evaluate(with: password)
            }
            .eraseToAnyPublisher()
    }
    
    var isPasswordEqualPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(passwordText, repeatPasswordText)
            .map { password, repeatPassword in
                return password == repeatPassword
            }
            .eraseToAnyPublisher()
    }
    
    var isSignupFormValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest4(
            isUserNameValidPublisher,
            isUserEmailValidPublisher,
            isPasswordValidPublisher,
            isPasswordEqualPublisher)
        .map { isNameValid, isEmailValid, isPasswordValid, passwordMatches in
            return isNameValid && isEmailValid && isPasswordValid && passwordMatches
        }
        .eraseToAnyPublisher()
    }
    
    
    var isMinNumberOfCharactersValidPublisher: AnyPublisher<Bool, Never> {
        passwordText
            .map { password in
                return password.count >= 8
            }
            .eraseToAnyPublisher()
    }
    
    var isContainLowerRegisterValidPublisher: AnyPublisher<Bool, Never> {
        passwordText
            .map { password in
                let lowercaseRegex = ".*[a-z]+.*"
                let lowercasePredicate = NSPredicate(format: "SELF MATCHES %@", lowercaseRegex)
                return lowercasePredicate.evaluate(with: password)
            }
            .eraseToAnyPublisher()
    }
    
    var isContainUpperRegisterValidPublisher: AnyPublisher<Bool, Never> {
        passwordText
            .map { password in
                let uppercaseRegex = ".*[A-Z]+.*"
                let uppercasePredicate = NSPredicate(format: "SELF MATCHES %@", uppercaseRegex)
                return uppercasePredicate.evaluate(with: password)
            }
            .eraseToAnyPublisher()
    }
    
    var isContainDigitValidPublisher: AnyPublisher<Bool, Never> {
        passwordText
            .map { password in
                let digitRegex = ".*\\d+.*"
                let digitPredicate = NSPredicate(format: "SELF MATCHES %@", digitRegex)
                return digitPredicate.evaluate(with: password)
            }
            .eraseToAnyPublisher()
    }
    
    var isContainSpecialCharacterValidPublisher: AnyPublisher<Bool, Never> {
        passwordText
            .map { password in
                let specialCharacterRegex = ".*[$@$!%*?&]+.*"
                let specialCharacterPredicate = NSPredicate(format: "SELF MATCHES %@", specialCharacterRegex)
                return specialCharacterPredicate.evaluate(with: password)
            }
            .eraseToAnyPublisher()
    }
}
