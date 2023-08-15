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
    var graphData: [String : Int]
    var radarData: [String: Int]
}

extension MyUser {
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "name": name,
            "photo": photo ?? "",
            "graphData": graphData,
            "radarData": radarData
        ]
    }
}
