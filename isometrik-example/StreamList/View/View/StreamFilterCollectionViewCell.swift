import UIKit
import IsometrikStreamUI

class StreamFilterCollectionViewCell: UICollectionViewCell, ISMAppearanceProvider {
    
    // MARK: - PROPERTIES
    
    override var isSelected: Bool {
        didSet {
            categoryLabelCoverView.backgroundColor = isSelected ? appearance.colors.appSecondary : .clear
            categoryLabel.textColor = isSelected ? appearance.colors.appColor : appearance.colors.appSecondary
            categoryLabelCoverView.layer.borderWidth = isSelected ? 0 : 1
        }
    }
    
    lazy var categoryLabelCoverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        view.layer.borderColor = appearance.colors.appColor.cgColor
        view.layer.cornerRadius = 17.5
        return view
    }()
    
    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = appearance.colors.appSecondary
        label.font = appearance.font.getFont(forTypo: .h8)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: MAIN -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: FUNCTIONS -
    
    func setUpViews(){
        backgroundColor = .clear
        addSubview(categoryLabelCoverView)
        categoryLabelCoverView.addSubview(categoryLabel)
    }
    
    func setUpConstraints(){
        categoryLabelCoverView.pin(to: self)
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            categoryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            categoryLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
}

