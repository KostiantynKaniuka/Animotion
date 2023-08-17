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
    private let chartVM = ChartViewModel()
    
    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
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
        chartView.xAxis.axisLineColor = .white
        chartView.xAxis.granularity = 1
        chartView.xAxis.valueFormatter = DayAxisValueFormatter(chart: chartView)
        chartView.animate(xAxisDuration: 1)
        
        return chartView
    }()
    
   private var data = [ChartDataEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor  = .clear
       
        view.addSubview(lineChartView)
        lineChartView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalToSuperview()
        }
        setUpAppearance()
        lineChartView.delegate = self
        fetchGraphData()
    }
    
    private func setChartData() {
        let set1 = LineChartDataSet(entries: data, label: "Mood Chart")
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
    
    
    private func fetchGraphData() {
        chartVM.getUserGraphData {
            DispatchQueue.main.async {  [weak self] in
                guard let self = self else { return }
                self.data = self.chartVM.chartData
                self.setChartData()
            }
        }
        
    }
}

extension ChartView: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
}

extension ChartView {
    
    private func setUpAppearance() {
        lineChartView.backgroundColor = .clear
        //lineChartView.layer.backgroundColor = UIColor.graphBackground.cgColor
        lineChartView.layer.cornerRadius = 10
        lineChartView.layer.borderWidth = 1
        lineChartView.layer.borderColor = UIColor.white.cgColor
    }
    
}
