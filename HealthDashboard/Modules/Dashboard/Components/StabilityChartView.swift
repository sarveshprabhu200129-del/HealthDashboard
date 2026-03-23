//
//  StabilityChartView.swift
//  HealthDashboard
//
//  Created by Sarvesh Prabhu on 22/03/26.
//

import UIKit
import DGCharts

class StabilityChartView: UIView {

    private var chartView: LineChartView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupChart()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupChart()
    }

    private func setupChart() {
        chartView = LineChartView()
        chartView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(chartView)

        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: topAnchor),
            chartView.bottomAnchor.constraint(equalTo: bottomAnchor),
            chartView.leadingAnchor.constraint(equalTo: leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        configureChartAppearance()
        loadChartData()
    }

    private func configureChartAppearance() {
        // General
        chartView.backgroundColor = .clear
        chartView.legend.enabled = false
        chartView.animate(xAxisDuration: 0.8, easingOption: .easeInOutQuart)

        // Disable interaction
        chartView.pinchZoomEnabled = false
        chartView.doubleTapToZoomEnabled = false
        chartView.dragEnabled = false

        // Right axis off
        chartView.rightAxis.enabled = false

        // X Axis
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 12, weight: .regular)
        xAxis.labelTextColor = .gray
        xAxis.drawGridLinesEnabled = false
        xAxis.drawAxisLineEnabled = false
        xAxis.granularity = 1
        xAxis.valueFormatter = MonthValueFormatter()

        // Y Axis (Left)
        let yAxis = chartView.leftAxis
        yAxis.labelFont = .systemFont(ofSize: 12, weight: .regular)
        yAxis.labelTextColor = .gray
        yAxis.drawGridLinesEnabled = true
        yAxis.gridColor = UIColor.lightGray.withAlphaComponent(0.3)
        yAxis.drawAxisLineEnabled = false
        yAxis.axisMinimum = 22
        yAxis.axisMaximum = 36
        yAxis.granularity = 4
        yAxis.valueFormatter = DayValueFormatter()
        yAxis.labelPosition = .outsideChart
    }

    private func loadChartData() {
        // Dummy data — Jan to Apr (0 to 3)
        // Line 1 — upper area (optimistic)
        let upperEntries: [ChartDataEntry] = [
            ChartDataEntry(x: 0, y: 24.5),
            ChartDataEntry(x: 1, y: 26.0),
            ChartDataEntry(x: 2, y: 30.0),
            ChartDataEntry(x: 3, y: 34.0)
        ]

        // Line 2 — lower area (conservative)
        let lowerEntries: [ChartDataEntry] = [
            ChartDataEntry(x: 0, y: 24.0),
            ChartDataEntry(x: 1, y: 25.0),
            ChartDataEntry(x: 2, y: 27.5),
            ChartDataEntry(x: 3, y: 31.0)
        ]

        // Highlight dot at Mar (x: 2)
        let dotEntries: [ChartDataEntry] = [
            ChartDataEntry(x: 2, y: 30.0)
        ]

        let upperDataSet = makeAreaDataSet(entries: upperEntries,
                                           color: UIColor(red: 0.6, green: 0.5, blue: 0.85, alpha: 1.0),
                                           fillAlpha: 0.25)

        let lowerDataSet = makeAreaDataSet(entries: lowerEntries,
                                           color: UIColor(red: 0.6, green: 0.5, blue: 0.85, alpha: 1.0),
                                           fillAlpha: 0.15)

        // Dot dataset
        let dotDataSet = LineChartDataSet(entries: dotEntries, label: "")
        dotDataSet.circleRadius = 7
        dotDataSet.circleColors = [UIColor(red: 0.4, green: 0.6, blue: 0.55, alpha: 1.0)]
        dotDataSet.circleHoleColor = UIColor(red: 0.4, green: 0.6, blue: 0.55, alpha: 1.0)
        dotDataSet.drawValuesEnabled = false
        dotDataSet.lineWidth = 0
        dotDataSet.drawCircleHoleEnabled = false

        // Dashed vertical line via limitLine
        let limitLine = ChartLimitLine(limit: 2, label: "")
        limitLine.lineColor = UIColor.darkGray.withAlphaComponent(0.6)
        limitLine.lineWidth = 1.0
        limitLine.lineDashLengths = [4, 4]
        limitLine.labelPosition = .rightTop
        chartView.xAxis.addLimitLine(limitLine)

        chartView.data = LineChartData(dataSets: [upperDataSet, lowerDataSet, dotDataSet])
    }

    private func makeAreaDataSet(entries: [ChartDataEntry],
                                  color: UIColor,
                                  fillAlpha: CGFloat) -> LineChartDataSet {
        let dataSet = LineChartDataSet(entries: entries, label: "")
        dataSet.mode = .cubicBezier
        dataSet.lineWidth = 0
        dataSet.drawCirclesEnabled = false
        dataSet.drawValuesEnabled = false

        // Fill area
        dataSet.drawFilledEnabled = true
        dataSet.fillAlpha = fillAlpha
        dataSet.fillColor = color
        dataSet.setColor(color.withAlphaComponent(0))

        return dataSet
    }
}

// MARK: - X Axis Month Formatter
class MonthValueFormatter: NSObject, AxisValueFormatter {
    private let months = ["Jan", "Feb", "Mar", "Apr"]

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let index = Int(value)
        guard index >= 0 && index < months.count else { return "" }
        return months[index]
    }
}

// MARK: - Y Axis Day Formatter
class DayValueFormatter: NSObject, AxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return "\(Int(value))d"
    }
}
