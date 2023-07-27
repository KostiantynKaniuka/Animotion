//
//  LoginViewModel.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 18.07.2023.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import AuthenticationServices
import CryptoKit

final class LoginViewModel {
    fileprivate var currentNonce: String?
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
    
    func formateAppleAuthError(_ error: ASAuthorizationError) -> String {
        switch error.code {
        case .unknown:
            return "The authorization attempt failed for an unknown reason"
        case .canceled:
            return "The user canceled the authorization attempt."
        case .invalidResponse:
            return "The authorization request received an invalid response."
        case .notHandled:
            return "The authorization request wasn’t handled."
        case .failed:
            return "The authorization attempt failed."
        case .notInteractive:
            return "The authorization request isn’t interactive."
        @unknown default:
            return "unknown error \(error.localizedDescription)"
        }
        
    }
    
    func showAlert(message: String, vc: LoginViewController) {
        let alertController = UIAlertController(title: "Oops", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        vc.present(alertController, animated: true, completion: nil)
    }
}

//MARK: - Sign in with Google
extension LoginViewModel {
    
    func loginWithGoogleDoc(_ rootViewController: UIViewController, completion: @escaping () -> Void)  {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {return}
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [unowned self] result, error in
            guard error == nil else {return}
            guard let result = result else {return}
            let userAuth = result.user
            guard let idToken = userAuth.idToken else {return}
            
            let accsesToken = userAuth.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                           accessToken: accsesToken.tokenString)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error as NSError? {
                    let message  = self.formateAuthError(error)
                    self.showAlert(message: message,
                                   vc: rootViewController as! LoginViewController)
                }
                if let authResult = authResult {
                    print(authResult.user)
                    completion()
                }
            }
        }
    }
}

//MARK: - Sign in with Apple
extension LoginViewModel {
    
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        return hashString
    }
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        return String(nonce)
    }
    
    func signInWithAppleCred(_ credential: OAuthCredential,vc: LoginViewController, completion: @escaping () -> Void) {
        Auth.auth().signIn(with: credential) { [weak self] (authResult, error) in
            guard let self = self else {return}
            if (error != nil) {
                if let error = error as NSError? {
                    let message  = self.formateAuthError(error)
                    self.showAlert(message: message,
                                   vc:vc)
                    return
                }
            }
        }
        completion()
    }
}
