//
//  ChartView.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 15.08.2023.
//

import UIKit
import SnapKit
import DGCharts

final class ChartView: UIViewController {
    
    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .black
        chartView.rightAxis.enabled = false
        let yAxis = chartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .white
        yAxis.axisLineColor = .white
        yAxis.labelPosition = .outsideChart
        
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        chartView.xAxis.setLabelCount(6, force: false)
        chartView.xAxis.labelTextColor = .white
        chartView.xAxis.axisLineColor = .systemBlue
        chartView.xAxis.granularity = 1
        chartView.xAxis.valueFormatter = DayAxisValueFormatter(chart: chartView)
        chartView.animate(xAxisDuration: 1)
        
        
        
        
        return chartView
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(lineChartView)
        lineChartView.snp.makeConstraints { make in
            make.center.equalTo(view.center)
            make.width.equalTo(view.snp.width)
            make.height.equalTo(lineChartView.snp.width)
        }
        
        setChartData()
    }
    
    
    func setChartData() {
        let set1 = LineChartDataSet(entries: data, label: "data smple")
        set1.mode = .cubicBezier
        set1.drawCirclesEnabled = false
        set1.lineWidth = 3
        set1.setColor(.white)
        set1.fill = ColorFill(color: .white)
        set1.fillAlpha = 0.8
        set1.drawFilledEnabled = true
        set1.drawHorizontalHighlightIndicatorEnabled = false
        let data = LineChartData(dataSet: set1)
        data.setDrawValues(false)
       lineChartView.data = data
        
    }
     
    var const = 0.08333333
    
    
    let data = [ChartDataEntry(x: 0.0, y: 1.0),
                ChartDataEntry(x: 1, y: 1.0),
                ChartDataEntry(x: 2, y: 3),
                ChartDataEntry(x: 3, y: 10),
                ChartDataEntry(x: 4, y: 4),
                ChartDataEntry(x: 5, y: 3),
                ChartDataEntry(x: 5.08333333, y: 6),
                ChartDataEntry(x: 5.16666667, y: 3),
                ChartDataEntry(x: 5.24999997, y: 4),
                ChartDataEntry(x: 5.3333333  , y: 5)
    ]
}

extension ChartView: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
}

