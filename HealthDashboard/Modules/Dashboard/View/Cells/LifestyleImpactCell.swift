//
//  LifestyleImpactCell.swift
//  HealthDashboard
//
//  Created by Sarvesh Prabhu on 21/03/26.
//
import UIKit


class LifestyleImpactCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var dropdownView: UIView!
    
    @IBOutlet weak var dropDownImage: UIImageView!
    @IBOutlet weak var dropdownLabel: UILabel!
    private var data: [CorrelationRow] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupCollection()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layoutIfNeeded()
    }

    func configure(data: [CorrelationRow]) {
        self.data = data
        collectionView.reloadData()
    }

    // MARK: - UI Setup
    private func setupUI() {
        selectionStyle = .none
        dropdownView.backgroundColor = UIColor(named: "Color_F7F6F6")
        dropdownView.layer.cornerRadius = 4
        containerView.layer.cornerRadius = 16
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.08
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 6
        containerView.backgroundColor = .white

        headerLabel.text = "Correlation Strength"
        headerLabel.font = UIFont(name: "DMSans-Medium", size: 14) ?? .systemFont(ofSize: 14, weight: .medium)
        headerLabel.textColor = UIColor(named: "Color_000000") ?? .black

        dropDownImage.image = UIImage(named: "dropdown")
        dropdownLabel.text = "4 months"
        dropdownLabel.font = UIFont(name: "DMSans-Regular", size: 10) ?? .systemFont(ofSize: 14, weight: .medium)
        dropdownLabel.textColor = UIColor(named: "Color_696770") ?? .black
    }

    @IBAction func dropdownCick(_ sender: Any) {
        let alert = UIAlertController(title: "Select Period",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        
        let months = ["1 month", "2 months", "3 months", "4 months", "6 months", "12 months"]
        
        months.forEach { month in
            alert.addAction(UIAlertAction(title: month, style: .default) { _ in
                self.dropdownLabel.text = "\(month)";
            })
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // Find the ViewController to present from
        parentViewController?.present(alert, animated: true)

    }
    
    // MARK: - Collection Setup
    private func setupCollection() {
        collectionView.delegate   = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear

        // Register label cell — no XIB needed
        collectionView.register(HeatmapLabelCell.self,
                                forCellWithReuseIdentifier: "HeatmapLabelCell")

        // Your existing HeatmapItemCell XIB
        collectionView.register(UINib(nibName: "HeatmapItemCell", bundle: nil),
                                forCellWithReuseIdentifier: "HeatmapItemCell")

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection         = .vertical
        layout.minimumLineSpacing      = 2
        layout.minimumInteritemSpacing = 0
        collectionView.collectionViewLayout = layout
    }
}

// MARK: - CollectionView
extension LifestyleImpactCell: UICollectionViewDelegate,
                               UICollectionViewDataSource,
                               UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count
    }

    // 1 label cell + 7 box cells
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 1 + data[section].values.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = data[indexPath.section]

        // First item = label
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "HeatmapLabelCell",
                for: indexPath) as! HeatmapLabelCell
            cell.configure(text: row.label)
            return cell
        }

        // Rest = colored boxes
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "HeatmapItemCell",
            for: indexPath) as! HeatmapItemCell
        let value = row.values[indexPath.item - 1]
        cell.configure(value: value, color: row.color)
        return cell
    }

    // MARK: - Item Size
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalWidth   = collectionView.bounds.width
        let labelWidth:  CGFloat = 50
        let itemCount:   CGFloat = CGFloat(data[indexPath.section].values.count)
        let totalSpacing = 4 * itemCount
        let boxWidth     = (totalWidth - labelWidth - totalSpacing) / itemCount

        if indexPath.item == 0 {
            return CGSize(width: labelWidth, height: 24)
        }
        return CGSize(width: boxWidth, height: 24)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
}

// MARK: - HeatmapLabelCell (pure code — no XIB)
class HeatmapLabelCell: UICollectionViewCell {

    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font      = UIFont(name: "DMSans-Regular", size: 12) ?? .systemFont(ofSize: 12)
        label.textColor = UIColor(named: "Color_000000") ?? .black
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configure(text: String) {
        label.text = text
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        var responder: UIResponder? = self
        while let r = responder {
            if let vc = r as? UIViewController { return vc }
            responder = r.next
        }
        return nil
    }
}
