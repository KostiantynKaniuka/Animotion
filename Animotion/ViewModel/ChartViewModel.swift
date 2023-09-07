//
//  ChartViewModel.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 16.08.2023.
//

import Foundation
import DGCharts
import FirebaseAuth

final class ChartViewModel {
    var chartData = [ChartDataEntry]()
    var reasonDictionary = [Int: String]()
    
    func getUserGraphData(comletion: @escaping () -> Void) {
        guard let user = Auth.auth().currentUser else {return}
        chartData = []
        reasonDictionary = [:]
        let id = user.uid
        print("➡️", id)
        
        FireAPIManager.shared.getReasonsFromDb(id: id) { [weak self]  data in
            guard let self = self else {return}
            
            for (key, value) in data {
                if let intKey = Int(key) {
                    self.reasonDictionary[intKey] = value
                }
            }
        }
            FireAPIManager.shared.getUserGraphData(id) { (keys, values) in
                print("data",keys, values)
                var tupleArray = [(Int,Double)]()
                let count = keys.count
                if count != values.count {
                    print("❌ Some key-value pairs are missing or mismatched")
                    return
                }
                
                for i in 0...count - 1 {
                    tupleArray.append((keys[i], values[i]))
                    if self.reasonDictionary[i] == nil {
                        self.reasonDictionary[i] = "Reason is not mentioned"
                    }
                }
                
                for i in 0...count - 1 {
                    let chartEntry = ChartDataEntry(x: tupleArray[i].1,
                                                    y: Double(tupleArray[i].0),
                                                    data: self.reasonDictionary[i])
                    self.chartData.append(chartEntry)
                }
                
                print("➡️ data", self.chartData)
                comletion()
            }
    }
}
