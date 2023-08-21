//
//  MenthalState.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 21.08.2023.
//

import Foundation

enum MethalState {
    case happy
    case good
    case anxious
    case sad
    case angry
    case satisfied
    
    static func fromString(_ string: String) -> MethalState? {
        switch string {
        case "Happy": return .happy
        case "Good": return .good
        case "Anxious": return .anxious
        case "Sad": return .sad
        case "Angry": return .angry
        case "Satisfied": return .satisfied
        default: return .satisfied
        }
    }
}
