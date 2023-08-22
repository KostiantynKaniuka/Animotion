//
//  CaptureMoodViewModel.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 14.08.2023.
//

import Foundation
import Combine

final class CaptureMoodViewModel: RadarParsable {
   
    
    static let moodPickerData = [1,2,3,4,5,6,7,8,9,10]
    static let menthalStatePickerData = ["Happy","Good","Satisfied","Anxious","Angry","Sad"]
    var moodData: Int = 1
    var PickerChoice: String = "Happy"
    var userMenthalString = ""
    
    var bag = Set<AnyCancellable>()
    
    var menthaldata = [String: Int]()
    
    
    func parseRadar(id: String, completion: @escaping ([String : Int]) -> Void) {
        FireAPIManager.shared.getRadarData(id: id) { data in
            completion(data)
        }
    }

    
    func sendUserChoice(id: String, completion: @escaping (GraphData, [String: Int]) -> Void ) {
        //graph logic start here
        let dateConverter = DateConvertor()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let currentDate = dateFormatter.string(from: Date())
        let formatedDate = dateFormatter.date(from: currentDate)
        let doubleDate = dateConverter.convertDateToNum(date: formatedDate!)
        let moodData = self.moodData
        let dataIndex = 1
        // radar logic {
        let userChoicekey = self.PickerChoice
        self.menthaldata[userChoicekey]! += 1
            //}
        FireAPIManager.shared.getDataIndex(id: id) { [weak self] index in
            guard let self = self else {return}
           let newIndex = index + dataIndex
            print(newIndex)
            let userGraph = GraphData(index: newIndex, date: doubleDate, value: moodData)
        
            
            completion(userGraph, self.menthaldata)
        }
    }

}
