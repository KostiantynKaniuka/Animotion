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
    case reset
    case submit
    case timer
    
    var title: String {
        switch self {
        case .error:
            return "Opps"
        case .verification:
            return "Please check your email"
        case .delete:
            return "Delete account?"
        case .reset:
            return "Please check your email"
        case .submit:
            return "Your data sended"
        case .timer:
            return "Capturing is not ready"
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
        case .reset:
            return "Please check your email and follow the instructions to reset your password."
        case .submit:
            return "Your mood chart will be updated soon. You can submit new values after 20 min"
        case .timer:
            return "until capturing"
        }
    }
}
