//
//  UserScreenViewModel.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 20.07.2023.
//

import UIKit
import Combine
import FirebaseAuth

protocol RadarParsable: AnyObject {
    func parseRadar(id: String, completion: @escaping ([String: Int]) -> Void)
}

final class UserScreenViewModel: RadarParsable {
    var menthalState: MethalState = .satisfied
    var username = CurrentValueSubject<String, Never>("user name")
    var bag = Set<AnyCancellable>()
    
    func parseRadar(id: String, completion: @escaping ([String: Int]) -> Void) {
        FireAPIManager.shared.getRadarData(id: id) { data in
            completion(data)
        }
    }
    
    func updateUserName(completion: @escaping () -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {return}
        FireAPIManager.shared.updateUserName(id: userId, newName: username.value) {
            completion()
        }
       
    }

    func parseUser(completion: @escaping () -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {return}
        
        FireAPIManager.shared.getUserFromDB(userId) { [weak self] user in
            guard let myUser = user else {
                print("fail to parse user")
                return
            }
            let user = MyUser(id: myUser.id, name: myUser.name, radarData: myUser.radarData)
            self?.username.value = user.name
            completion()
        }
    }
    
    func setChartColor(data: [String: Int] ) -> UIColor {
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
            return .gray
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
