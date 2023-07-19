//
//  LoginViewModel.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 18.07.2023.
//

import Foundation
import Combine

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
    
}
