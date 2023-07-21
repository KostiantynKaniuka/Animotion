//
//  AuthStateViewModel.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 20.07.2023.
//

import UIKit
import FirebaseAuth
import Combine

enum AuthenticationState {
  case unauthenticated
  case authenticating
  case authenticated
}

final class AuthStateViewModel {
    private var user: User?
    private(set) var authenticationState: CurrentValueSubject<AuthenticationState, Never> = .init(.authenticating)
    var bag = Set<AnyCancellable>()

    private var authStateHandle: AuthStateDidChangeListenerHandle?
    
    init() {
        registerAuthStateHandler()
    }
    
    func registerAuthStateHandler() {
        if authStateHandle == nil {
            authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
                if let user = user {
                    self?.user = user
                    self?.authenticationState.value = .authenticated
                } else {
                    self?.authenticationState.value = .unauthenticated
                }
            }
        }
    }
}
