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
    
    func addingDataToDb(name: String, completion: @escaping (Error?) -> Void) {
        let db = configureFB()
        ref = db.child("CarouselData").child(name)
        ref.setValue([ "imageUrl": "",
                       "descriptionText": "",
                       "linkToBlog": ""]) {(error, _) in
            print("✅ data added" )
            completion(error)
        }
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
                                let vieolink = dataDict["vieoLink"] as? String ?? ""
                                
                                let sidemenuItem = UkraineSection(image: image, location: location, name: name, videoLink: vieolink)
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
                                let vieolink = dataDict["vieoLink"] as? String ?? ""
        
                                let sidemenuItem = SafeSpace(image: image, name: name, videoLink: vieolink)
                                sideMenuData.append(sidemenuItem)
                                print("➡️", sideMenuData.count)
                            }
                        }
                    }
                    completion(sideMenuData)
        })
    }
}
