//
//  DateValueFormatter.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 15.08.2023.
//

import Foundation
import DGCharts

public class DateValueFormatter: NSObject, AxisValueFormatter {
    private let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
        dateFormatter.dateFormat = "dd MMM HH:mm"
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}

