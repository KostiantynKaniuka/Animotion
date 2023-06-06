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
                            }
                        }
                    }
                    
                    completion(carouselData)
        })
    }
    
    func addingDataToDb(completion: @escaping (Error?) -> Void) {
        let db = configureFB()
        ref = db.child("CarouselData").child("healthline")
        ref.setValue([ "imageUrl": "",
                       "descriptionText": "",
                       "linkToBlog": ""]) {(error, _) in
            completion(error)
        }
    }
}
