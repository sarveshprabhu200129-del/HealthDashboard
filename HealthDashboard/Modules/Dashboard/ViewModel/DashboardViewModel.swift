//
//  DashboardViewModel.swift
//  HealthDashboard
//
//  Created by Sarvesh Prabhu on 21/03/26.
//

import Foundation
import UIKit

import UIKit

// MARK: - Section Enum
enum DashboardSection: Int, CaseIterable {
    case stability
    case cycle
    case bodyTrends
    case bodySignals
    case correlation
}

struct CorrelationRow {
    let label: String
    let values: [CGFloat] // 0.0 to 1.0
    let color: UIColor
}

// MARK: - ViewModel

class DashboardViewModel {

    // MARK: Correlation (Heatmap)
    var correlationData: [CorrelationRow] {
        return  [
            CorrelationRow(label: "Sleep",    values: [1.0, 0.85, 0.75, 0.65, 0.55, 0.0, 0.0], color: UIColor(red: 0.72, green: 0.67, blue: 0.90, alpha: 1.0)),
            CorrelationRow(label: "Hydrate",  values: [1.0, 0.85, 0.70, 0.60, 0.50, 0.40, 0.0], color: UIColor(red: 0.91, green: 0.65, blue: 0.63, alpha: 1.0)),
            CorrelationRow(label: "Caffeine", values: [0.90, 0.75, 0.60, 0.0, 0.0, 0.0, 0.0],   color: UIColor(red: 0.55, green: 0.75, blue: 0.68, alpha: 1.0)),
            CorrelationRow(label: "Exercise", values: [0.70, 0.55, 0.40, 0.0, 0.0, 0.0, 0.0],   color: UIColor(red: 0.91, green: 0.75, blue: 0.78, alpha: 1.0)),
        ]
    }
}

extension UIColor {

    static let softPurple = UIColor(red: 155/255, green: 140/255, blue: 255/255, alpha: 1)

    static let softRed = UIColor(red: 255/255, green: 120/255, blue: 120/255, alpha: 1)

    static let softGreen = UIColor(red: 120/255, green: 200/255, blue: 160/255, alpha: 1)

    static let softPink = UIColor(red: 255/255, green: 160/255, blue: 180/255, alpha: 1)
}
