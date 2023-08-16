//
//  User.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 14.08.2023.
//

import Foundation

struct MyUser {
    let id: String
    var name: String
    var photo: String?
    var radarData: [String: Int]
}

struct GraphData: Encodable {
    let date: [String: Double]
    let value: [String: Int]
}

extension MyUser {
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "name": name,
            "photo": photo ?? "",
            "radarData": radarData
        ]
    }}
    
extension GraphData {
    func graphToDictionary() -> [String: Any] {
        return [
            "date": date,
            "value": value
        ]
    }
}

extension Encodable {
    var toDictionnary: [String : Any]? {
        guard let data =  try? JSONEncoder().encode(self) else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
    }
}
