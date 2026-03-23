//
//  CycleTrendsChartView.swift
//  HealthDashboard
//
//  Created by Sarvesh Prabhu on 22/03/26.
//

import UIKit

struct CycleBarData {
    let total: Int
    let topPurple: CGFloat
    let greenColorBar: CGFloat
    let middlePurple: CGFloat
    let pinkColorBar: CGFloat
    let bottomPurple: CGFloat
}

class CycleTrendsChartView: UIView {

    private let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun","July", "Aug"]

    private let data: [CycleBarData] = [
        CycleBarData(total: 28, topPurple: 5, greenColorBar: 12, middlePurple: 5, pinkColorBar: 4,bottomPurple:2),
        CycleBarData(total: 30, topPurple: 4, greenColorBar: 10, middlePurple: 4, pinkColorBar: 10,bottomPurple:2),
        CycleBarData(total: 28, topPurple: 5, greenColorBar: 5, middlePurple: 8, pinkColorBar: 5,bottomPurple:5),
        CycleBarData(total: 32, topPurple: 5, greenColorBar: 10, middlePurple: 2, pinkColorBar: 10,bottomPurple:5),
        CycleBarData(total: 34, topPurple: 5, greenColorBar: 10, middlePurple: 8, pinkColorBar: 6,bottomPurple:5),
        CycleBarData(total: 28, topPurple: 5, greenColorBar: 8, middlePurple: 5, pinkColorBar: 7,bottomPurple:3),
        CycleBarData(total: 38, topPurple: 5, greenColorBar: 10, middlePurple: 8, pinkColorBar: 10,bottomPurple:5),
        CycleBarData(total: 32, topPurple: 5, greenColorBar: 10, middlePurple: 2, pinkColorBar: 10,bottomPurple:5)
    ]

    // Colors from asset catalog
    private let purpleColor   = UIColor(named: "Color_B4A8DA") ?? UIColor(red: 0.71, green: 0.66, blue: 0.85, alpha: 1.0)
    private let greenColor    = UIColor(named: "Color_6E8C82") ?? UIColor(red: 0.43, green: 0.55, blue: 0.51, alpha: 1.0)
    private let pinkColor     = UIColor(named: "Color_E99597") ?? UIColor(red: 0.91, green: 0.58, blue: 0.59, alpha: 1.0)

    // Layout
    private let barWidth:     CGFloat = 18
    private let barSpacing:   CGFloat = 28
    private let topPad:       CGFloat = 36
    private let bottomPad:    CGFloat = 28
    private let cornerRadius: CGFloat = 10
    private let arrowSize:    CGFloat = 18

    private var scrollView:  UIScrollView!
    private var contentView: UIView!
    private var leftButton:  UIButton!
    private var rightButton: UIButton!

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

        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.clipsToBounds = true
        addSubview(scrollView)

        contentView = UIView()
        contentView.backgroundColor = .clear
        scrollView.addSubview(contentView)

        leftButton  = setImage(imageName: "roundedCircleBack")
        rightButton = setImage(imageName: "roundedCircle")

        leftButton.addTarget(self,  action: #selector(scrollLeft),  for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(scrollRight), for: .touchUpInside)
        addSubview(leftButton)
        addSubview(rightButton)

        NSLayoutConstraint.activate([
            leftButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            leftButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            leftButton.widthAnchor.constraint(equalToConstant: arrowSize),
            leftButton.heightAnchor.constraint(equalToConstant: arrowSize),

            rightButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2),
            rightButton.widthAnchor.constraint(equalToConstant: arrowSize),
            rightButton.heightAnchor.constraint(equalToConstant: arrowSize),

            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leftButton.trailingAnchor, constant: 4),
            scrollView.trailingAnchor.constraint(equalTo: rightButton.leadingAnchor, constant: -4),
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard bounds.width > 0, bounds.height > 0 else { return }
        drawBars()
    }

    private func drawBars() {
        contentView.subviews.forEach { $0.removeFromSuperview() }

        let availableH = bounds.height - topPad - bottomPad
        let maxTotal   = CGFloat(data.map { $0.total }.max() ?? 32)

        let totalContentWidth = CGFloat(data.count) * (barWidth + barSpacing) - barSpacing
        contentView.frame = CGRect(x: 0, y: 0, width: totalContentWidth, height: bounds.height)
        scrollView.contentSize = CGSize(width: totalContentWidth, height: bounds.height)

        for (i, item) in data.enumerated() {
            let x         = CGFloat(i) * (barWidth + barSpacing)
            let barHeight = (CGFloat(item.total) / maxTotal) * availableH
            let barY      = topPad + (availableH - barHeight)

            // Bar container
            let bar = UIView()
            bar.frame = CGRect(x: x, y: barY, width: barWidth, height: barHeight)
            bar.layer.cornerRadius = cornerRadius
            bar.clipsToBounds = true
            contentView.addSubview(bar)

            let totalDays = item.topPurple + item.greenColorBar + item.middlePurple + item.pinkColorBar + item.bottomPurple
            let topPurpleH    = (item.topPurple    / totalDays) * barHeight
            let greenColorBarH = (item.greenColorBar / totalDays) * barHeight
            let middlePurpleH   = (item.middlePurple   / totalDays) * barHeight
            let pinkColorBarH    = (item.pinkColorBar    / totalDays) * barHeight
            let bottomPurpleH    = (item.bottomPurple    / totalDays) * barHeight
            
            var currentY: CGFloat = 0

            addSegment(to: bar, color: purpleColor,
                       frame: CGRect(x: 0, y: currentY, width: barWidth, height: topPurpleH))
            currentY += topPurpleH
            
            let greenView = addSegment(to: bar, color: greenColor,
                       frame: CGRect(x: 0, y: currentY, width: barWidth, height: greenColorBarH))

            let gearIcon = UIImageView(image: UIImage(named: "imgCycleGraph1"))
            gearIcon.tintColor = .white.withAlphaComponent(0.9)
            gearIcon.contentMode = .scaleAspectFit
            let iconSize: CGFloat = 8
            gearIcon.frame = CGRect(
                x: (barWidth - iconSize) / 2,
                y: (greenColorBarH - iconSize) / 2,
                width: iconSize, height: iconSize
            )
            greenView.addSubview(gearIcon)
            currentY += greenColorBarH

            addSegment(to: bar, color: purpleColor.withAlphaComponent(0.5),
                       frame: CGRect(x: 0, y: currentY, width: barWidth, height: middlePurpleH))
            currentY += middlePurpleH

            let pinkView = addSegment(to: bar, color: pinkColor,
                           frame: CGRect(x: 0, y: currentY, width: barWidth, height: pinkColorBarH))

            let dropIcon = UIImageView(image: UIImage(named: "imgCycleGraph2"))
            dropIcon.tintColor = .white.withAlphaComponent(0.9)
            dropIcon.contentMode = .scaleAspectFit
            dropIcon.frame = CGRect(
                x: (barWidth - iconSize) / 2,
                y: (pinkColorBarH - iconSize) / 2,
                width: iconSize, height: iconSize
            )
            pinkView.addSubview(dropIcon)

            currentY += pinkColorBarH

            addSegment(to: bar, color: purpleColor,
                       frame: CGRect(x: 0, y: currentY, width: barWidth, height: bottomPurpleH))
            currentY += bottomPurpleH

            // Total label
            let totalLabel = UILabel()
            totalLabel.text = "\(item.total)"
            totalLabel.font = .systemFont(ofSize: 11, weight: .semibold)
            totalLabel.textColor = .darkGray
            totalLabel.textAlignment = .center
            totalLabel.frame = CGRect(x: x, y: barY - 20, width: barWidth, height: 16)
            contentView.addSubview(totalLabel)

            // Month label
            let monthLabel = UILabel()
            monthLabel.text = months[i]
            monthLabel.font = .systemFont(ofSize: 11)
            monthLabel.textColor = .gray
            monthLabel.textAlignment = .center
            monthLabel.frame = CGRect(x: x - 8, y: bounds.height - bottomPad + 4,
                                      width: barWidth + 16, height: 16)
            contentView.addSubview(monthLabel)
        }
    }

    @discardableResult
    private func addSegment(to parent: UIView, color: UIColor, frame: CGRect) -> UIView {
        let v = UIView(frame: frame)
        v.backgroundColor = color
        parent.addSubview(v)
        return v
    }
    
    private func setImage(imageName: String) -> UIButton {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false

        btn.setImage((UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)), for: .normal)

        btn.imageView?.contentMode = .scaleAspectFit
        btn.clipsToBounds = true

        return btn
    }

    @objc private func scrollLeft() {
        let step = barWidth + barSpacing
        let newX = max(scrollView.contentOffset.x - step, 0)
        scrollView.setContentOffset(CGPoint(x: newX, y: 0), animated: true)
    }

    @objc private func scrollRight() {
        let step = barWidth + barSpacing
        let maxX = scrollView.contentSize.width - scrollView.bounds.width
        let newX = min(scrollView.contentOffset.x + step, maxX)
        scrollView.setContentOffset(CGPoint(x: newX, y: 0), animated: true)
    }
}
