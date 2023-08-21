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
    
    func getUserGraphData(comletion: @escaping () -> Void) {
        guard let user = Auth.auth().currentUser else {return}
        chartData = []
        let id = user.uid
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
            }
            tupleArray.forEach( { (key,value) in
                let chartEntry = ChartDataEntry(x: value, y: Double(key))
                self.chartData.append(chartEntry)
            })
            print(self.chartData)
            comletion()
        }
    }
}
