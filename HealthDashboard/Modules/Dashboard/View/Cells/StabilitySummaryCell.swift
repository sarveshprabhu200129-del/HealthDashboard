//
//  StabilitySummaryCell.swift
//  HealthDashboard
//
//  Created by Sarvesh Prabhu on 21/03/26.
//
import UIKit

class StabilitySummaryCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var graphView: StabilityChartView!
    @IBOutlet weak var gradientView: UIView!
    
    private var glowLayer: CAGradientLayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layoutIfNeeded()
        graphView.layoutIfNeeded()
        applyGradient(to: gradientView)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        selectionStyle = .none
        containerView.layer.cornerRadius = 16
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.08
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 6
        containerView.backgroundColor = .white
        
        lblSubtitle.font = UIFont(name: "DMSans-Regular", size: 14)
        lblSubtitle.textColor = UIColor(named: "Color_696770")
        lbltitle.font = UIFont(name: "DMSans-Regular", size: 16)
        lbltitle.textColor = UIColor(named: "Color_000000")
        lblScore.font = UIFont(name: "DMSans-SemiBold", size: 20)
        lblScore.textColor = UIColor(named: "Color_000000")
        
        lbltitle.textColor = UIColor(named: "Color_696770")
        lblSubtitle.text = "Based on your recent logs and symptom patterns."
        lbltitle.text = "Stability Score"
        lblScore.text = "78%"

    }
    
    private func applyGradient(to myview: UIView) {
        myview.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })

        let glowColor = UIColor(named: "Color_6E8C82")!

        let gradientLayer = CAGradientLayer()
        gradientLayer.type = .radial

        // Large frame, anchored to top-left area
        let size = myview.bounds.width * 1.8
        gradientLayer.frame = CGRect(x: myview.bounds.width - size * 0.75, y: -size * 0.2, width: size, height: size)

        gradientLayer.colors = [
            glowColor.withAlphaComponent(0.30).cgColor,  // brighter
            glowColor.withAlphaComponent(0.10).cgColor,
            glowColor.withAlphaComponent(0.0).cgColor
        ]

        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint   = CGPoint(x: 1.0, y: 1.0)

        myview.layer.insertSublayer(gradientLayer, at: 0)
    }
}
