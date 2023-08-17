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
    fileprivate var graphIndex: Int = 0 //Graph database indexing do not modify
    
    static let shared = FireAPIManager()
    private var ref: DatabaseReference!
    
    private func configureFB() -> DatabaseReference {
        let db = Database.database().reference()
        
        return db
    }
    
    
    //MARK: - ADD
    //MARK: - Adding user to db
    func addingUserToFirebase(user: MyUser) {
        let db = configureFB()
        let usersRef = db.child("users")
        let userRef = usersRef.child("\(user.id)")
        userRef.setValue(user.toDictionary())
        }
    
    func addGraphData(id:String, graphData: GraphData) {
        let db = configureFB()
        let graphRef = db.child("graphData")
        let userRef = graphRef.child("graphdataFor\(id)")
        let dataRef = userRef.child("data")
        let valueRef = dataRef.child("value")
        let dateRef = dataRef.child("date")
        valueRef.setValue(["\(graphIndex)" : graphData.value])
        dateRef.setValue(["\(graphIndex)" : graphData.date])
        
        graphIndex += 1
    }
    
    
    //MARK: - GET
    //MARK: - Carousel data
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
                     let radarData = dataDict["radarData"] as? [String: Int] ?? [:]
                     userData = MyUser(id: id, name: name, radarData: radarData)
                 }
           completion(userData)
        })
    }
    
    
    func getUserGraphData(_ id: String, completion: @escaping (([Int],[Double])) -> Void){
        let db = configureFB()
        let valueRef = db.child("graphData").child("graphdataFor\(id)").child("data").child("value")
        let dateRef = db.child("graphData").child("graphdataFor\(id)").child("data").child("date")
        var valuesArray = [Double]()
        var keysArray = [Int]()
        
        dateRef.getData { error, values in
            if let error = error {
                print("Error fetching graph data: \(error)")
                return
            }
            
            if let data = values?.value as? [Double] {
                valuesArray = data
            }
        }
        
        valueRef.getData { error, values in
            if let error = error {
                print("Error fetching graph data: \(error)")
                return
            }
            
            if let data = values?.value as? [Int] {
                keysArray = data
                completion((keysArray, valuesArray))
            }
        }
    }

    //MARK: - Get Ukraine Data
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
    
    //MARK: - Get SafeSpaceData
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
    
    //MARK: - UPDATE
    
    func updateGraphData(id: String, graphData: GraphData) {
        let db = configureFB()
        let graphRef = db.child("graphData")
        let userRef = graphRef.child("graphdataFor\(id)")
        let dataRef = userRef.child("data")
        let valueRef = dataRef.child("value")
        let dateRef = dataRef.child("date")
        
        valueRef.updateChildValues(["\(graphIndex)" : graphData.value])
        dateRef.updateChildValues(["\(graphIndex)" : graphData.date])
        
        graphIndex += 1
    }
}
