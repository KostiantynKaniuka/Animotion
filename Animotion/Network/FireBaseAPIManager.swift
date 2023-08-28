//
//  FireBaseAPIManager.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 06.06.2023.
//

import Foundation
import FirebaseCore
import FirebaseDatabase
import Combine

class FireAPIManager {
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
    
    func addGraphData(id:String, graphData:GraphData, reason: String) {
        let db = configureFB()
        let graphRef = db.child("graphData")
        let userRef = graphRef.child("\(id)")
        let dataRef = userRef.child("data")
        let dataIndex = dataRef.child("dataIndex")
        let valueRef = dataRef.child("value")
        let dateRef = dataRef.child("date")
        let reasonRef = userRef.child("reasons")
        
        dataIndex.setValue(["Index" : graphData.index])
        valueRef.setValue(["\(0)" : graphData.value])
        dateRef.setValue(["\(0)" : graphData.date])
        reasonRef.setValue(["\(0)": "Starting point"])
    }
    
    //MARK: - GET
    
    func getRadarData(id:String, completion: @escaping ([String: Int]) -> Void) {
        let db = configureFB()
        let radarRef = db.child("users").child("\(id)").child("radarData")
        
        radarRef.getData { error, data in
            if let error = error as? NSError{
                print("fail to parse radar", error.localizedDescription)
                return
            }
            
            if let data = data?.value as? [String:Int] {
                print(data)
                completion(data)
            }
        }
    }
    
    
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
    
    func getDataIndex(id: String, completion: @escaping (Int) -> Void) {
        let db = configureFB()
        let indexRef = db.child("graphData").child("\(id)").child("data").child("dataIndex").child("Index")
        
        indexRef.getData { error, index in
            if let error = error {
                print("Error fetching graph data: \(error)")
                return
            }
            
            if let index = index?.value as? Int {
                print(index)
                completion(index)
            }
        }
    }
    
    func checkUserIndb(_ id: String, completion: @escaping (Bool) -> Void) {
        let db = configureFB()
        db.child("users").child(id).observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                print("👨‍💼 User exists")
                completion(true)
            } else {
                print("🚫 User does not exist")
                completion(false)
            }
        }
    }
    
    
    
    
    func getReasons(id: String, completion: @escaping (Result<[String: String], Error>) -> Void) {
        guard let url = URL(string: "https://api.jsonbin.io/v3/b/64e9ef14b89b1e2299d64846") else {
            print("❌ Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Error:", error)
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let noDataError = NSError(domain: "No data received", code: 0, userInfo: nil)
                print("❌ No data received")
                completion(.failure(noDataError))
                return
            }
            
            do {
                let responseData = try JSONDecoder().decode(UserReasons.self, from: data)
                //print(responseData)
                completion(.success(responseData.record[id] ?? ["": ""]))
            } catch {
                print("❌ Error decoding:", error)
                completion(.failure(error))
            }
        }.resume()
    }
    
    
    func addReason(id: String, newReason: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "https://api.jsonbin.io/v3/b/64e9ef14b89b1e2299d64846") else {
            print("❌ Invalid URL")
            return
        }
        
        // Fetch the existing data
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Error:", error)
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let noDataError = NSError(domain: "No data received", code: 0, userInfo: nil)
                print("❌ No data received")
                completion(.failure(noDataError))
                return
            }
            
            do {
                var responseData = try JSONDecoder().decode(UserReasons.self, from: data)
                
                // Update the data for the specific ID
                if var existingReasons = responseData.record[id] {
                    // You can add a new reason or modify existing ones
                    existingReasons["2"] = newReason
                    responseData.record[id] = existingReasons
                    
                    // Convert the updated data to JSON
                    let updatedData = try JSONEncoder().encode(responseData)
                    
                    // Prepare the request
                    var request = URLRequest(url: url)
                    request.httpMethod = "PUT"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.httpBody = updatedData
                    
                    // Send the updated data back to the server
                    URLSession.shared.dataTask(with: request) { _, _, error in
                        if let error = error {
                            print("❌ Error sending updated data:", error)
                            completion(.failure(error))
                        } else {
                            completion(.success(()))
                        }
                    }.resume()
                } else {
                    let idNotFoundError = NSError(domain: "User ID not found", code: 0, userInfo: nil)
                    completion(.failure(idNotFoundError))
                }
            } catch {
                print("❌ Error decoding:", error)
                completion(.failure(error))
            }
        }.resume()
    }
    
    
    
    func getReasonsFromDb(id: String, completion: @escaping ([String: String]) -> Void) {
        let db = configureFB()
        let valueRef = db.child("graphData").child(id).child("reasons")
        print("Fetching data from:", valueRef.url)
        
        valueRef.getData { error, dataSnapshot in
            if let error = error {
                print("Error fetching data for ID:", id)
                print("Error:", error.localizedDescription)
                completion(["1": "error"])
                return
            }
            
            guard let reasonSnap = dataSnapshot, let reasonArray = reasonSnap.value as? [Any] else {
                print("Data could not be cast as [Any]")
                print("Raw data:", dataSnapshot?.value ?? "nil")
                completion(["1": "error"])
                return
            }
            
            var reasonDictionary: [String: String] = [:]
            for (index, reasonValue) in reasonArray.enumerated() {
                if let reason = reasonValue as? String {
                    reasonDictionary[String(index)] = reason
                }
            }
            
            print("➡️ Reasons", reasonDictionary)
            completion(reasonDictionary)
        }
        
    }
    
    
    func getUserGraphData(_ id: String, completion: @escaping (([Int],[Double])) -> Void){
        let db = configureFB()
        let valueRef = db.child("graphData").child("\(id)").child("data").child("value")
        let dateRef = db.child("graphData").child("\(id)").child("data").child("date")
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
                print(keysArray, valuesArray)
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
    
    
    func updateUserName(id: String, newName: String, completion: @escaping () -> Void) {
        let db = configureFB()
        let userNameRef = db.child("users").child("\(id)")

        userNameRef.updateChildValues(["name": newName])
        completion()
    }
    
    func updateUserChartsData(id: String, reason: String, graphData: GraphData, radarData: [String: Int] ,completion: @escaping () -> Void) {
        let db = configureFB()
        let userGraphRef = db.child("graphData").child("\(id)")
        let dataRef = userGraphRef.child("data")
        let indexRef = dataRef.child("dataIndex")
        let valueRef = dataRef.child("value")
        let dateRef = dataRef.child("date")
        let reasonRef = userGraphRef.child("reasons")
        let userRadarRef = db.child("users").child("\(id)").child("radarData")
        
        indexRef.updateChildValues(["Index": graphData.index])
        valueRef.updateChildValues(["\(graphData.index)" : graphData.value])
        dateRef.updateChildValues(["\(graphData.index)" : graphData.date])
        if reason != "" {
            reasonRef.updateChildValues(["\(graphData.index)": reason])
        }
        userRadarRef.updateChildValues(radarData)
        
        completion()
    }
    
    
    //MARK: - DELETE
    
    func deleteAccountData(id: String, completion: @escaping () -> Void) {
        let db = configureFB()
        db.child("graphData").child("\(id)").removeValue()
        db.child("users").child("\(id)").removeValue()
        completion()
    }
}
