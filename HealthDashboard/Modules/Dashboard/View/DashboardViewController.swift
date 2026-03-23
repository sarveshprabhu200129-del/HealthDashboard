//
//  DashboardViewController.swift
//  HealthDashboard
//
//  Created by Sarvesh Prabhu on 21/03/26.
//

import UIKit

class DashboardViewController: UIViewController, UITableViewDelegate {

    private let viewModel = DashboardViewModel()
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var topImg:UIImageView!
    @IBOutlet weak var gradientVieew:UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = UIColor(named: "Color_F5FAF9")
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        applyGradient(to: gradientVieew)
    }

    private func applyGradient(to myview: UIView) {
        myview.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })

        let glowColor = UIColor(named: "Color_E99597")!

        let gradientLayer = CAGradientLayer()
        gradientLayer.type = .radial

        // Large frame, anchored to top-left area
        let size = myview.bounds.width * 2.2
        gradientLayer.frame = CGRect(x: -size * 0.2, y: -size * 0.2, width: size, height: size)

        gradientLayer.colors = [
            glowColor.withAlphaComponent(0.45).cgColor,
            glowColor.withAlphaComponent(0.15).cgColor,
            glowColor.withAlphaComponent(0.0).cgColor
        ]

        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint   = CGPoint(x: 1.0, y: 1.0)

        myview.layer.insertSublayer(gradientLayer, at: 0)
    }

    
    private func setupUI() {
        titleLabel.font = UIFont(name: "DMSans-SemiBold", size: 16)
        titleLabel.textColor = UIColor(named: "Color_000000")
        
        titleLabel.text = "Insights"
        
        topImg.image = (UIImage(named: "imgNav"))
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }

        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear

        tableView.register(UINib(nibName: "StabilitySummaryCell", bundle: nil),
                           forCellReuseIdentifier: "StabilitySummaryCell")

        tableView.register(UINib(nibName: "CycleTrendsCell", bundle: nil),
                           forCellReuseIdentifier: "CycleTrendsCell")

        tableView.register(UINib(nibName: "BodyTrendsCell", bundle: nil),
                           forCellReuseIdentifier: "BodyTrendsCell")

        tableView.register(UINib(nibName: "BodySignalsCell", bundle: nil),
                           forCellReuseIdentifier: "BodySignalsCell")

        tableView.register(UINib(nibName: "LifestyleImpactCell", bundle: nil),
                           forCellReuseIdentifier: "LifestyleImpactCell")
    }
}

// MARK: - Section Enum
extension DashboardViewController {

    enum DashboardSection: Int, CaseIterable {
        case stability
        case cycle
        case bodyTrends
        case bodySignals
        case lifestyle

        var title: String {
            switch self {
            case .stability: return "Stability Summary"
            case .cycle: return "Cycle Trends"
            case .bodyTrends: return "Body & Metabolic Trends"
            case .bodySignals: return "Body Signals"
            case .lifestyle: return "Lifestyle Impact"
            }
        }
    }
}

// MARK: - TableView DataSource
extension DashboardViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return DashboardSection.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let section = DashboardSection(rawValue: indexPath.section)!

        switch section {

        case .stability:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StabilitySummaryCell", for: indexPath) as! StabilitySummaryCell
            return cell

        case .cycle:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CycleTrendsCell",
                                                     for: indexPath) as! CycleTrendsCell
            return cell

        case .bodyTrends:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BodyTrendsCell",
                                                     for: indexPath) as! BodyTrendsCell
            return cell

        case .bodySignals:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BodySignalsCell",
                                                     for: indexPath) as! BodySignalsCell
            return cell

        case .lifestyle:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LifestyleImpactCell",
                                                     for: indexPath) as! LifestyleImpactCell
            cell.configure(data: viewModel.correlationData)
            return cell
        }
    }
}

// MARK: - Section Header
extension DashboardViewController {

    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {

        let label = UILabel()
        label.text = DashboardSection(rawValue: section)?.title
        label.font = UIFont(name: "DMSans-Bold", size: 18) ?? UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black

        let container = UIView()
        container.backgroundColor = tableView.backgroundColor
        container.addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -4)
        ])

        return container
    }

    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

class RadialGlowView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2

        // #E99597 → R: 233/255, G: 149/255, B: 151/255
        let glowColor = UIColor(red: 233/255, green: 149/255, blue: 151/255, alpha: 1.0)

        let colorSpace = CGColorSpaceCreateDeviceRGB()

        let colors: [CGColor] = [
            glowColor.withAlphaComponent(0.55).cgColor,  // strong center
            glowColor.withAlphaComponent(0.25).cgColor,  // mid fade
            glowColor.withAlphaComponent(0.0).cgColor    // transparent edge
        ]

        let locations: [CGFloat] = [0.0, 0.45, 1.0]

        guard let gradient = CGGradient(
            colorsSpace: colorSpace,
            colors: colors as CFArray,
            locations: locations
        ) else { return }

        context.drawRadialGradient(
            gradient,
            startCenter: center,
            startRadius: 0,
            endCenter: center,
            endRadius: radius,
            options: .drawsBeforeStartLocation
        )
    }
}
