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
        let id = user.uid
        FireAPIManager.shared.getUserGraphData(id) { (keys, values) in
            var graphDictionary = [Int: Double]()
            let count = min(keys.count, values.count) //check if two arrays are coming
            for i in 0..<count  {
                graphDictionary[keys[i]] = values[i]
            }
            
            let sortedGraph = graphDictionary.sorted { $0.value < $1.value }
            
            for entry in sortedGraph {
                let chartEntry = ChartDataEntry(x: entry.value, y: Double(entry.key))
                self.chartData.append(chartEntry)
            }
            comletion()
        }
    }
}
