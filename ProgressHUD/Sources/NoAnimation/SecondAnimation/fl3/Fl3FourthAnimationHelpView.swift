import UIKit

public final class Fl3FourthAnimationHelpView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor.black
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor.gray
        label.numberOfLines = 0
        
        return label
    }()
    
    private let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var textStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        
        stack.axis = .vertical
        stack.spacing = 2
        stack.alignment = .leading
        
        return stack
    }()
    
    var isOptionSelected: Bool = false {
        didSet {
            updateSelectionState()
        }
    }
    
    var onTap: (() -> Void)?
    
    public var model: AuthorizationOfferModel?
    public var premium: SubscriptionModel?
    
    init(title: String, description: String, isSelected: Bool = false, _ model: AuthorizationOfferModel? = nil, premium: SubscriptionModel?) {
        super.init(frame: .zero)
        
        self.titleLabel.text = title
        self.descriptionLabel.text = description
        self.isOptionSelected = isSelected
        self.model = model
        self.premium = premium
        setupView()
        updateSelectionState()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = UIColor.white
        layer.cornerRadius = 20
        layer.masksToBounds = false
        
        // Shadow properties
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        
        let mainStackView = UIStackView(arrangedSubviews: [textStackView, checkmarkImageView])
        
        mainStackView.axis = .horizontal
        mainStackView.spacing = 12
        mainStackView.alignment = .center
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 24),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func updateSelectionState() {
        if isOptionSelected {
            guard let iconURL = URL(string: model?.flow3?.fl3_top_circle_act ?? "") else { return }
            
            checkmarkImageView.kf.setImage(with: iconURL, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
            
            layer.borderColor = UIColor.systemBlue.cgColor
            layer.borderWidth = 2.0
        } else {
            guard let iconURL = URL(string: model?.flow3?.fl3_top_circle ?? "") else { return }
            
            checkmarkImageView.kf.setImage(with: iconURL, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
            
            layer.borderColor = UIColor.clear.cgColor
            layer.borderWidth = 0.0
        }
    }
    
    @objc private func handleTap() {
        onTap?()
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            if isOptionSelected {
                layer.borderColor = UIColor.systemBlue.cgColor
            } else {
                layer.borderColor = UIColor.clear.cgColor
            }

            layer.shadowColor = UIColor.black.cgColor
        }
    }
}

