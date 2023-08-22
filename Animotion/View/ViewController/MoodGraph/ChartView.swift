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
        let marker = ChartMarker()
        marker.chartView = chartView
        chartView.marker = marker
        
        return chartView
    }()
    
    private var data = [ChartDataEntry]()
    private var reasonsDict = [Int: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor  = .clear
        view.addSubview(lineChartView)
        lineChartView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalToSuperview()
        }
        
        lineChartView.delegate = self
        setUpAppearance()
        fetchGraphData()
    }
    
    private func setChartData() {
        let set1 = LineChartDataSet(entries: data, label: "Mood Chart")
        print(set1.count)
        set1.mode = .cubicBezier
        set1.drawCirclesEnabled = true
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
        chartVM.getUserGraphData { [weak self]  in
            guard let self = self else {return}
            DispatchQueue.main.async { [self] in
                self.data = []
                self.data = self.chartVM.chartData
                self.setChartData()
            }
        }
    }
}

extension ChartView: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry.data ?? "nodata")
      
    }
}

extension ChartView {
    
    private func setUpAppearance() {
        lineChartView.backgroundColor = .clear
        lineChartView.layer.cornerRadius = 10
        lineChartView.layer.borderWidth = 1
        lineChartView.layer.borderColor = UIColor.white.cgColor
    }
}

extension ChartView: GraphDataDelegate {
    func refetchGraphData() {
     fetchGraphData()
    }
}


class ChartMarker: MarkerView {
    private var text = String()

    private let drawAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 15),
        .foregroundColor: UIColor.darkGray,
        .backgroundColor: UIColor.clear
    ]

    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        text = entry.data as? String ?? ""
    }

    override func draw(context: CGContext, point: CGPoint) {
        super.draw(context: context, point: point)

        let sizeForDrawing = text.size(withAttributes: drawAttributes)
        bounds.size = sizeForDrawing
        offset = CGPoint(x: -sizeForDrawing.width / 2, y: -sizeForDrawing.height - 4)

        let offset = offsetForDrawing(atPoint: point)
        let originPoint = CGPoint(x: point.x + offset.x, y: point.y + offset.y)
        let rectForText = CGRect(origin: originPoint, size: sizeForDrawing)
        drawText(text: text, rect: rectForText, withAttributes: drawAttributes)
    }

    private func drawText(text: String, rect: CGRect, withAttributes attributes: [NSAttributedString.Key: Any]? = nil) {
        let size = bounds.size
        let centeredRect = CGRect(
            x: rect.origin.x + (rect.size.width - size.width) / 2,
            y: rect.origin.y + (rect.size.height - size.height) / 2,
            width: size.width,
            height: size.height
        )
        text.draw(in: centeredRect, withAttributes: attributes)
    }
}
