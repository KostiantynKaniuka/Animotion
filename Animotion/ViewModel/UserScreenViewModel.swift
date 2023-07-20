//
//  UserScreenViewModel.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 20.07.2023.
//

import UIKit
import Combine
import FirebaseAuth

final class UserScreenViewModel {
    var bag = Set<AnyCancellable>()
    
    func showAlert(title: String, message: String,
                   vc: UserScreenViewController,
                   handler:((UIAlertAction) -> Void)? = nil,
                   cancelhadler: UIAlertAction? = nil) {
        
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK",
                                     style: .default,
                                     handler: handler)
        
        alertController.addAction(okAction)
        
        if cancelhadler != nil {
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: .destructive,
                                             handler: nil)
            
            alertController.addAction(cancelAction)
        }
        vc.present(alertController, animated: true, completion: nil)
    }
    
    func formateAuthError(_ error: NSError) -> String {
        switch error.code {
        case AuthErrorCode.networkError.rawValue:
            return "Network Error"
        default:
            return "unknown error: \(error.localizedDescription)"
        }
    }
}
