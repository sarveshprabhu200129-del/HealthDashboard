//
//  SymptomTrendsChartView.swift
//  HealthDashboard
//
//  Created by Sarvesh Prabhu on 22/03/26.
//

import UIKit
import SwiftUI
import Charts

@available(iOS 17.0, *)
struct SymptomDonutChart: View {

    let data: [SymptomData] = [
        SymptomData(name: "Mood",     value: 30, color: Color(red: 0.91, green: 0.78, blue: 0.78)),
        SymptomData(name: "Bloating", value: 31, color: Color(red: 0.72, green: 0.70, blue: 0.88)),
        SymptomData(name: "Fatigue",  value: 21, color: Color(red: 0.91, green: 0.58, blue: 0.58)),
        SymptomData(name: "Acne",     value: 17, color: Color(red: 0.65, green: 0.78, blue: 0.73))
    ]

    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
            let donutSize = size * 0.68          // donut chart size
            let labelRadius = size / 2 * 0.75      // push labels outside the donut

            ZStack {
                // Donut
                Chart(data, id: \.name) { item in
                    SectorMark(
                        angle: .value("Value", item.value),
                        innerRadius: .ratio(0.72),
                        angularInset: 3
                    )
                    .foregroundStyle(item.color)
                    .cornerRadius(4)
                }
                .frame(width: donutSize, height: donutSize)
                .position(x: center.x, y: center.y)

                // Center text
                VStack(spacing: 2) {
                    Text("Symptom")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.gray)
                    Text("Trends")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.gray)
                }
                .position(x: center.x, y: center.y)

                // Pill labels outside
                ForEach(data, id: \.name) { item in
                    let angle = labelAngle(for: item)
                    let x     = center.x + labelRadius * cos(angle)
                    let y     = center.y + labelRadius * sin(angle)

                    pillLabel(item: item)
                        .position(x: x, y: y)
                }
            }
        }
        .padding(8)
    }

    @ViewBuilder
    private func pillLabel(item: SymptomData) -> some View {
        VStack(spacing: 1) {
            Text("\(item.value)%")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.black)
            Text(item.name)
                .font(.system(size: 10, weight: .regular))
                .foregroundColor(.gray)
        }
        .frame(width: 54, height: 44)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.10), radius: 6, x: 0, y: 2)
        )
    }

    private func labelAngle(for item: SymptomData) -> CGFloat {
        let total = data.reduce(0) { $0 + $1.value }
        var startAngle: CGFloat = -.pi / 2
        for d in data {
            let slice = CGFloat(d.value) / CGFloat(total) * 2 * .pi
            if d.name == item.name {
                return startAngle + slice / 2
            }
            startAngle += slice
        }
        return 0
    }
}

struct SymptomData {
    let name: String
    let value: Int
    let color: Color
}

@available(iOS 17.0, *)
class SymptomTrendsChartView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor = .clear
        let hostingController = UIHostingController(rootView: SymptomDonutChart())
        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hostingController.view)
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
