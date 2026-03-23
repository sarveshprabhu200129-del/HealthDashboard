//
//  BodySignalsCell.swift
//  HealthDashboard
//
//  Created by Sarvesh Prabhu on 21/03/26.
//

import UIKit

class BodySignalsCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var graphView: SymptomTrendsChartView!


    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layoutIfNeeded()
    }

    // MARK: - UI Setup
    private func setupUI() {
        selectionStyle = .none

        // Card UI
        containerView.layer.cornerRadius = 16
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.08
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 6
        containerView.backgroundColor = .white

        // Labels
        titleLabel.text = "Body Signals"
        titleLabel.font = UIFont(name: "DMSans-SemiBold", size: 16)
        titleLabel.textColor = UIColor(named: "Color_000000") ?? UIColor.black

        subtitleLabel.text = "Compared to last cycle"
        titleLabel.font = UIFont(name: "DMSans-Regular", size: 14)
        titleLabel.textColor = UIColor(named: "Color_696770") ?? UIColor.gray
    }

}
