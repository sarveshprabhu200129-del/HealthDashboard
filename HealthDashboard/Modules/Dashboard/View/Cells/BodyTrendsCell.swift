//
//  BodyTrendsCell.swift
//  HealthDashboard
//
//  Created by Sarvesh Prabhu on 21/03/26.
//

import UIKit
import DGCharts

class BodyTrendsCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var graphView: BodyMetabolicChartView!

    // Dummy data stored in cell
    private let monthlyEntries: [ChartDataEntry] = [
        ChartDataEntry(x: 0, y: 28),
        ChartDataEntry(x: 1, y: 32),
        ChartDataEntry(x: 2, y: 55),
        ChartDataEntry(x: 3, y: 72),
        ChartDataEntry(x: 4, y: 60),
        ChartDataEntry(x: 5, y: 58)
    ]
    private let monthlyLabels = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]

    private let weeklyEntries: [ChartDataEntry] = [
        ChartDataEntry(x: 0, y: 55),
        ChartDataEntry(x: 1, y: 58),
        ChartDataEntry(x: 2, y: 54),
        ChartDataEntry(x: 3, y: 60),
        ChartDataEntry(x: 4, y: 57),
        ChartDataEntry(x: 5, y: 62),
        ChartDataEntry(x: 6, y: 59)
    ]
    private let weeklyLabels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        // Load monthly by default
        graphView.loadData(entries: monthlyEntries, labels: monthlyLabels)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layoutIfNeeded()
    }

    // MARK: - UI Setup
    private func setupUI() {
        selectionStyle = .none

        titleLabel.font = UIFont(name: "DMSans-Medium", size: 14)
        titleLabel.textColor = UIColor(named: "Color_000000")

        subtitleLabel.font = UIFont(name: "DMSans-Regular", size: 12)
        subtitleLabel.textColor = UIColor(named: "Color_696770")

        containerView.layer.cornerRadius = 16
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.08
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 6
        containerView.backgroundColor = .white

        titleLabel.text = "Your Weight"
        subtitleLabel.text = "in kg"

        setupSegmentedControl()
    }

    private func setupSegmentedControl() {
        segmentedControl.removeAllSegments()
        segmentedControl.insertSegment(withTitle: "Monthly", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Weekly",  at: 1, animated: false)
        segmentedControl.selectedSegmentIndex = 0

        segmentedControl.backgroundColor = UIColor(named: "Color_F7F6F6") ?? UIColor.systemGray6
        segmentedControl.selectedSegmentTintColor = UIColor(named: "Color_000000") ?? UIColor.black

        segmentedControl.setTitleTextAttributes([
            .foregroundColor: UIColor(named: "Color_FFFFFF") ?? UIColor.white
        ], for: .selected)

        segmentedControl.setTitleTextAttributes([
            .foregroundColor: UIColor(named: "Color_696770") ?? UIColor.gray
        ], for: .normal)
    }

    // MARK: - Segment Action
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            graphView.loadData(entries: monthlyEntries, labels: monthlyLabels)
        } else {
            graphView.loadData(entries: weeklyEntries, labels: weeklyLabels)
        }
    }
}
