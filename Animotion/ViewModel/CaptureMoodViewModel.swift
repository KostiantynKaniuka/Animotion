//
//  CaptureMoodViewModel.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 14.08.2023.
//

import Foundation
import Combine

final class CaptureMoodViewModel {
    static let moodPickerData = [1,2,3,4,5,6,7,8,9,10]
    static let menthalStatePickerData = ["Happy","Good","Satisfied","Anxious","Angry","Sad"]
    var moodData: Int = 1
    var methalData: String = "Happy"
    var bag = Set<AnyCancellable>()
    
    var menthalCount: [String: Int] = [
        "Happy": 0,
        "Good": 0,
        "Satisfied": 0,
        "Anxious": 0,
        "Angry": 0,
        "Sad": 0
    ]
    
    
}