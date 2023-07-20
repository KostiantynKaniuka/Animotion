//
//  AlertMessage.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 20.07.2023.
//

import Foundation

enum AlertMessage {
    case error
    case verification
    case delete
    
    var title: String {
        switch self {
        case .error:
            return "Opps"
        case .verification:
            return "Please check your email"
        case .delete:
            return "Delete account?"
        }
    }
    
    var body: String {
        switch self {
        case .error:
            return ""
        case .verification:
           return "Please check your email and follow the instructions to activate your account."
        case .delete:
            return "Are you sure that you want to delete the account? All data will be erased."
        }
    }
}
