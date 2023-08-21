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
    var menthalState: MethalState = .satisfied
    
    var bag = Set<AnyCancellable>()
    
    var menthalCount: [String: Double] = [
        "Happy": 3,
        "Good": 12,
        "Satisfied": 4,
        "Anxious": 15,
        "Angry": 3,
        "Sad": 13
    ]
    
    
    
    func setChartColor(data: [String: Double] ) -> UIColor {
        if let maxKey = data.max(by: { $0.value < $1.value })?.key {
            menthalState = MethalState.fromString("\(maxKey)")!
        } else {
            menthalState = .satisfied
        }

        switch menthalState {
        case .happy:
            return .green
        case .good:
            return .relaxedGreen
        case .anxious:
            return .cyan
        case .sad:
            return .darkGray
        case .angry:
            return .red
        case .satisfied:
            return .lightGray
        }
    }
    
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
