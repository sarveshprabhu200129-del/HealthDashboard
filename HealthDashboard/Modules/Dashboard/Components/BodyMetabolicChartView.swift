//
//  BodyMetabolicChartView.swift
//  HealthDashboard
//
//  Created by Sarvesh Prabhu on 22/03/26.
//

import UIKit
import DGCharts

class BodyMetabolicChartView: UIView {

    private var chartView: LineChartView!

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: - Setup
    private func setup() {
        chartView = LineChartView()
        chartView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(chartView)

        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: topAnchor),
            chartView.bottomAnchor.constraint(equalTo: bottomAnchor),
            chartView.leadingAnchor.constraint(equalTo: leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        configureAppearance()
    }

    // MARK: - Appearance
    private func configureAppearance() {
        chartView.backgroundColor = .clear
        chartView.legend.enabled = false
        chartView.pinchZoomEnabled = false
        chartView.doubleTapToZoomEnabled = false
        chartView.dragEnabled = false
        chartView.rightAxis.enabled = false

        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 11)
        xAxis.labelTextColor = .gray
        xAxis.drawGridLinesEnabled = false
        xAxis.drawAxisLineEnabled = false
        xAxis.granularity = 1

        let yAxis = chartView.leftAxis
        yAxis.labelFont = .systemFont(ofSize: 11)
        yAxis.labelTextColor = .gray
        yAxis.drawGridLinesEnabled = true
        yAxis.gridColor = UIColor.lightGray.withAlphaComponent(0.3)
        yAxis.gridLineDashLengths = [4, 4]
        yAxis.drawAxisLineEnabled = false
        yAxis.axisMinimum = 20
        yAxis.axisMaximum = 80
        yAxis.granularity = 25
    }

    // MARK: - Public Load Data
    func loadData(entries: [ChartDataEntry], labels: [String]) {
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: labels)

        let dataSet = LineChartDataSet(entries: entries, label: "")
        dataSet.mode = .cubicBezier
        dataSet.lineWidth = 2.0
        dataSet.setColor(UIColor(red: 0.91, green: 0.58, blue: 0.58, alpha: 1.0))
        dataSet.drawCirclesEnabled = true
        dataSet.circleRadius = 4
        dataSet.circleColors = [UIColor(red: 0.91, green: 0.58, blue: 0.58, alpha: 1.0)]
        dataSet.circleHoleColor = .white
        dataSet.circleHoleRadius = 2
        dataSet.drawValuesEnabled = false
        dataSet.drawFilledEnabled = true
        dataSet.fillColor = UIColor(red: 0.91, green: 0.58, blue: 0.58, alpha: 1.0)
        dataSet.fillAlpha = 0.15

        chartView.data = LineChartData(dataSets: [dataSet])
        chartView.animate(xAxisDuration: 0.5, easingOption: .easeInOutQuart)
    }
}
