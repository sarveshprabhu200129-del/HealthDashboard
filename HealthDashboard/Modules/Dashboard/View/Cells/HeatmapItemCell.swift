//
//  HeatmapItemCell.swift
//  HealthDashboard
//
//  Created by Sarvesh Prabhu on 21/03/26.
//

import UIKit

class HeatmapItemCell: UICollectionViewCell {
    @IBOutlet weak var boxView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        boxView.layer.cornerRadius = 4
    }
    
    func configure(value: Double, color: UIColor) {

        if value == 0 {
            boxView.backgroundColor = UIColor.systemGray5
        } else {
            boxView.backgroundColor = color.withAlphaComponent(value)
        }
    }

}
