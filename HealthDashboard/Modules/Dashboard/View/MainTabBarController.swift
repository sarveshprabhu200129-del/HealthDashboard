//
//  MainTabBarController.swift
//  HealthDashboard
//
//  Created by Sarvesh Prabhu on 22/03/26.
//

import UIKit

class MainTabBarController: UITabBarController {

    private var customTabBar: CustomTabBarView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupCustomTabBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        selectedIndex = 2
        customTabBar.selectTab(at: 2)
    }

    private func setupTabs() {
        let homeVC     = PlaceholderViewController()
        let trackVC    = PlaceholderViewController()
        let insightsVC = DashboardViewController()
        let addVC      = UIViewController()

        viewControllers = [
            UINavigationController(rootViewController: homeVC),
            UINavigationController(rootViewController: trackVC),
            UINavigationController(rootViewController: insightsVC),
            addVC
        ]

        tabBar.isHidden = true
    }

    private func setupCustomTabBar() {
        customTabBar = CustomTabBarView()
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        customTabBar.delegate = self
        view.addSubview(customTabBar)

        NSLayoutConstraint.activate([
            customTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            customTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            customTabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            customTabBar.heightAnchor.constraint(equalToConstant: 68),
        ])
    }
}


// MARK: - Delegate
extension MainTabBarController: CustomTabBarDelegate {
    func didSelectTab(at index: Int) {
        if index == 3 {
            showAlert(feature: "Add")
            return
        }
        if index != 2 {
            customTabBar.selectTab(at: 2)
            let names = ["Home", "Track", "Insights"]
            showAlert(feature: names[index])
            return
        }
        selectedIndex = index
    }

    private func showAlert(feature: String) {
        let alert = UIAlertController(
            title: "Coming Soon...",
            message: "The \(feature) isn’t ready yet, but we’re working on it and it will be available soon!",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Protocol
protocol CustomTabBarDelegate: AnyObject {
    func didSelectTab(at index: Int)
}

// MARK: - CustomTabBarView
class CustomTabBarView: UIView {

    weak var delegate: CustomTabBarDelegate?

    private let tabItems = [
        TabItem(title: "Home",     normalImage: "imgHome",   selectedImage: "imgHomeSelected"),
        TabItem(title: "Track",    normalImage: "imgTrack",         selectedImage: "imgTrackSelected"),
        TabItem(title: "Insights", normalImage: "imgInsights",      selectedImage: "imgInsightsSelected"),
    ]

    private var tabButtons: [UIButton] = []
    private var selectedIndex = 2

    private let groupPill  = UIView()
    private let addButton  = UIButton(type: .custom)

    override init(frame: CGRect) {
        super.init(frame: frame)
        build()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        build()
    }

    private func build() {
        backgroundColor = .clear

        // MARK: - Group Pill
        groupPill.backgroundColor = UIColor.white.withAlphaComponent(0.20)
        groupPill.layer.cornerRadius = 34
        groupPill.layer.shadowColor = UIColor.black.withAlphaComponent(0.4).cgColor
        groupPill.layer.shadowOpacity = 1.0
        groupPill.layer.shadowOffset = CGSize(width: 0, height: 4)
        groupPill.layer.shadowRadius = 12
        groupPill.clipsToBounds = false
        groupPill.translatesAutoresizingMaskIntoConstraints = false
        addSubview(groupPill)

        // Blur effect inside group pill
        let blurGroup = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        blurGroup.translatesAutoresizingMaskIntoConstraints = false
        blurGroup.layer.cornerRadius = 34
        blurGroup.clipsToBounds = true
        groupPill.insertSubview(blurGroup, at: 0)

        NSLayoutConstraint.activate([
            blurGroup.topAnchor.constraint(equalTo: groupPill.topAnchor),
            blurGroup.bottomAnchor.constraint(equalTo: groupPill.bottomAnchor),
            blurGroup.leadingAnchor.constraint(equalTo: groupPill.leadingAnchor),
            blurGroup.trailingAnchor.constraint(equalTo: groupPill.trailingAnchor),
        ])

        // MARK: - Stack
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        groupPill.addSubview(stack)

        for (i, item) in tabItems.enumerated() {
            let btn = buildTabButton(item: item, index: i)
            tabButtons.append(btn)
            stack.addArrangedSubview(btn)
        }

        // MARK: - Add Button
        addButton.backgroundColor = UIColor.white.withAlphaComponent(0.20)
        addButton.layer.cornerRadius = 30
        addButton.layer.shadowColor = UIColor.black.withAlphaComponent(0.4).cgColor
        addButton.layer.shadowOpacity = 1.0
        addButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        addButton.layer.shadowRadius = 12
        addButton.clipsToBounds = false
        addButton.translatesAutoresizingMaskIntoConstraints = false

        // Blur effect inside add button
        let blurAdd = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        blurAdd.translatesAutoresizingMaskIntoConstraints = false
        blurAdd.layer.cornerRadius = 34
        blurAdd.clipsToBounds = true
        blurAdd.isUserInteractionEnabled = false
        addButton.addSubview(blurAdd)
        addButton.bringSubviewToFront(addButton.imageView!)

        NSLayoutConstraint.activate([
            blurAdd.topAnchor.constraint(equalTo: addButton.topAnchor),
            blurAdd.bottomAnchor.constraint(equalTo: addButton.bottomAnchor),
            blurAdd.leadingAnchor.constraint(equalTo: addButton.leadingAnchor),
            blurAdd.trailingAnchor.constraint(equalTo: addButton.trailingAnchor),
        ])

        // + icon
        let plusConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .light)
        addButton.setImage(UIImage(systemName: "plus", withConfiguration: plusConfig), for: .normal)
        addButton.tintColor = UIColor(red: 0.41, green: 0.40, blue: 0.42, alpha: 1.0)
        addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        addSubview(addButton)

        NSLayoutConstraint.activate([
            // + button right side
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            addButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 68),
            addButton.heightAnchor.constraint(equalToConstant: 68),

            // Group pill fills remaining left space
            groupPill.leadingAnchor.constraint(equalTo: leadingAnchor),
            groupPill.topAnchor.constraint(equalTo: topAnchor),
            groupPill.bottomAnchor.constraint(equalTo: bottomAnchor),
            groupPill.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -10),

            // Stack fills pill
            stack.topAnchor.constraint(equalTo: groupPill.topAnchor),
            stack.bottomAnchor.constraint(equalTo: groupPill.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: groupPill.leadingAnchor, constant: 8),
            stack.trailingAnchor.constraint(equalTo: groupPill.trailingAnchor, constant: -8),
        ])
    }

    private func buildTabButton(item: TabItem, index: Int) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.tag = index

        let iconSize = CGSize(width: 26, height: 26)
        let normalImg   = UIImage(named: item.normalImage)?
            .resized(to: iconSize).withRenderingMode(.alwaysTemplate)
        let selectedImg = UIImage(named: item.selectedImage)?
            .resized(to: iconSize).withRenderingMode(.alwaysTemplate)

        // Use imageView + label manually for proper stacking
        let iconView = UIImageView(image: normalImg)
        iconView.highlightedImage = selectedImg
        iconView.tintColor = UIColor(red: 0.55, green: 0.54, blue: 0.56, alpha: 1.0)
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.tag = 100

        let titleLbl = UILabel()
        titleLbl.text = item.title
        titleLbl.font = UIFont(name: "DMSans-Regular", size: 11) ?? .systemFont(ofSize: 11)
        titleLbl.textColor = UIColor(red: 0.55, green: 0.54, blue: 0.56, alpha: 1.0)
        titleLbl.textAlignment = .center
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.tag = 101

        let vStack = UIStackView(arrangedSubviews: [iconView, titleLbl])
        vStack.axis = .vertical
        vStack.alignment = .center
        vStack.spacing = 3
        vStack.isUserInteractionEnabled = false
        vStack.translatesAutoresizingMaskIntoConstraints = false

        btn.addSubview(vStack)
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 26),
            iconView.heightAnchor.constraint(equalToConstant: 26),
            vStack.centerXAnchor.constraint(equalTo: btn.centerXAnchor),
            vStack.centerYAnchor.constraint(equalTo: btn.centerYAnchor),
        ])

        btn.addTarget(self, action: #selector(tabTapped(_:)), for: .touchUpInside)
        return btn
    }

    // MARK: - Select
    func selectTab(at index: Int) {
        selectedIndex = index

        for (i, btn) in tabButtons.enumerated() {
            let isSelected = (i == index)
            let iconView = btn.viewWithTag(100) as? UIImageView
            let titleLbl = btn.viewWithTag(101) as? UILabel

            let selectedColor = UIColor.black
            let normalColor   = UIColor(red: 0.55, green: 0.54, blue: 0.56, alpha: 1.0)

            iconView?.isHighlighted = isSelected
            iconView?.tintColor     = isSelected ? selectedColor : normalColor
            titleLbl?.textColor     = isSelected ? selectedColor : normalColor
            titleLbl?.font = isSelected
                ? (UIFont(name: "DMSans-Medium", size: 11) ?? .systemFont(ofSize: 11, weight: .medium))
                : (UIFont(name: "DMSans-Regular", size: 11) ?? .systemFont(ofSize: 11))
        }

        setNeedsLayout()
        layoutIfNeeded()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
    }

    @objc private func tabTapped(_ sender: UIButton) {
        delegate?.didSelectTab(at: sender.tag)
    }

    @objc private func addTapped() {
        delegate?.didSelectTab(at: 3)
    }
}

// MARK: - Models & Helpers
struct TabItem {
    let title: String
    let normalImage: String
    let selectedImage: String
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

class PlaceholderViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }
}
