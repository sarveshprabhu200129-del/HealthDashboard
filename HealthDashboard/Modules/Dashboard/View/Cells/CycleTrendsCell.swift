//
//  CycleTrendsCell.swift
//  HealthDashboard
//
//  Created by Sarvesh Prabhu on 21/03/26.
//
import UIKit

class CycleTrendsCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var graphView: CycleTrendsChartView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layoutIfNeeded()
    }

    private func setupUI() {
        selectionStyle = .none

        containerView.layer.cornerRadius = 16
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.08
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 6
        containerView.backgroundColor = .white
    }
}
