//
//  FireBaseAPIManager.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 06.06.2023.
//

import Foundation
import FirebaseCore
import FirebaseDatabase

class FireAPIManager {
    
    static let shared = FireAPIManager()
    var ref: DatabaseReference!
    
    private func configureFB() -> DatabaseReference {
        let db = Database.database().reference()
        
        return db
    }
    
    func getCarouselDataFromdb(completion:  @escaping ([CarouselData]) -> Void ) {
        let db = configureFB()
        db.child("CarouselData").getData(completion: { error, snapshot in
            guard error == nil else {
               print(error!.localizedDescription)
               return;
             }
            var carouselData: [CarouselData] = []
                    
            if let value = snapshot?.value as? [String: Any] {
                        for (_, data) in value {
                            if let dataDict = data as? [String: String] {
                                let imageUrl = dataDict["imageUrl"] ?? ""
                                let descriptionText = dataDict["descriptionText"] ?? ""
                                let linkToBlog = dataDict["linkToBlog"] ?? ""
                                
                                let carouselItem = CarouselData(imageUrl: imageUrl, descriptionText: descriptionText, linkToBlog: linkToBlog)
                                carouselData.append(carouselItem)
                                print("➡️", carouselData.count)
                            }
                        }
                    }
                    
                    completion(carouselData)
        })
    }
    
    func addingUserToFirebase(user: MyUser) {
        let db = configureFB()
        let usersRef = db.child("users")
        let userRef = usersRef.child("\(user.id)")
        userRef.setValue(user.toDictionary())
        }
    
    func getUserFromDB(_ id: String, completion: @escaping (MyUser?) -> Void) {
        let db = configureFB()
      
        db.child("users").child(id).getData(completion: { error, user in
            guard error == nil else {
                print(error?.localizedDescription ?? "❌ oops no user")
                completion(nil)
                return
            }
            var userData: MyUser?
            
                 if let dataDict = user?.value as? [String: Any] {
                     let id = dataDict["id"] as? String ?? ""
                     let name = dataDict["name"] as? String ?? ""
                     let graphData = dataDict["graphData"] as? [String: Int] ?? [:]
                     let radarData = dataDict["radarData"] as? [String: Int] ?? [:]
                     
                     userData = MyUser(id: id, name: name, graphData: graphData, radarData: radarData)
                 }
           completion(userData)
        })
    }

    
    func getUkraineMenuData(completion: @escaping ([UkraineSection]) -> Void) {
        let db = configureFB()
        db.child("Ukraine").getData(completion: { error, snapshot in
            guard error == nil else {
               print(error!.localizedDescription)
               return;
             }
            var sideMenuData: [UkraineSection] = []
                    
            if let value = snapshot?.value as? [String: Any] {
                        for (_, data) in value {
                            if let dataDict = data as? [String: Any] {
                                let image = dataDict["image"]  as? String ?? ""
                                let location = dataDict["location"] as? String ?? ""
                                let name = dataDict["name"] as? String ?? ""
                                let videolink = dataDict["videoLink"] as? String ?? ""
                                let sidemenuItem = UkraineSection(image: image, location: location, name: name, videoLink: videolink)
                                sideMenuData.append(sidemenuItem)
                                print("➡️", sideMenuData.count)
                            }
                        }
                    }
                    completion(sideMenuData)
        })
    }
    
    func getSafeSpaceMenuData(completion: @escaping ([SafeSpace]) -> Void) {
        let db = configureFB()
        db.child("sidemenu").getData(completion: { error, snapshot in
            guard error == nil else {
               print(error!.localizedDescription)
               return;
             }
            var sideMenuData: [SafeSpace] = []
                    
            if let value = snapshot?.value as? [String: Any] {
                        for (_, data) in value {
                            if let dataDict = data as? [String: Any] {
                                let image = dataDict["image"]  as? String ?? ""
                                let name = dataDict["name"] as? String ?? ""
                                let videolink = dataDict["videoLink"] as? String ?? ""
        
                                let sidemenuItem = SafeSpace(image: image, name: name, videoLink: videolink)
                                sideMenuData.append(sidemenuItem)
                                print("➡️", sideMenuData.count)
                            }
                        }
                    }
                    completion(sideMenuData)
        })
    }
}
