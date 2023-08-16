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

struct GraphData {
    let data: [Double:Int]
    let value: [Int]
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
